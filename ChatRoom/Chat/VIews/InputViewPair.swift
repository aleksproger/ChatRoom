//
//  InputViewPair.swift
//  ChatRoom
//
//  Created by Alex on 04.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit
import Combine

class InputViewPair: UIView {
    
    private(set) var topView = TranslationInputView(.engToRus, viewModel: TranslationInputViewModel())
    private(set) var bottomView = TranslationInputView(.rusToEng, viewModel: TranslationInputViewModel())
    
    var subscriptions = Set<AnyCancellable>()
    var swipeMade = PassthroughSubject<TranslationType, Never>()
    var viewModel: InputPairViewModel?
    
    convenience init(_ viewModel: InputPairViewModel) {
        self.init(frame: .zero)
        self.viewModel = viewModel
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(topView)
        addSubview(bottomView)
        subscribeToSendTap()
        subscribeToClearTap()
        subscribeToRecordTap()
        subscribeToMicroTap()
        bottomView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:))))
        topView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:))))
    }
    
    
    override func layoutSubviews() {
        let insets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        topView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: 44)
        topView.frame = topView.frame.inset(by: insets)
        bottomView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: 44)
        bottomView.frame = bottomView.frame.inset(by: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4))
        bottomView.center = CGPoint(x: bounds.size.width/2.0, y: bounds.size.height/2.0 + 44)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        guard isEnoughSpeedToRecognizePan(recognizer: recognizer) else {
            return
        }
        moveTheView(recognizer: recognizer)
        if recognizer.state == UIGestureRecognizer.State.ended {
            let recognizerView = recognizer.view as! TranslationInputView
            swipeMade.send(recognizerView.translationType)
            UIView.animate(withDuration: 1) {
                recognizer.view?.center.x = (self.center.x)
            }
        } else {
            animateSlidingBack(recognizer: recognizer)
        }
    }
    
    func animateSlidingBack(recognizer: UIPanGestureRecognizer) {
        let velocity = recognizer.velocity(in: self)
        let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
        let slideMultiplier = magnitude / 100
        print("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
        
        let slideFactor = 0.1 * slideMultiplier
        let finalPoint = CGPoint(x: self.center.x,
                                 y: recognizer.view!.center.y)
        UIView.animate(withDuration: Double(slideFactor * 0.25),
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {recognizer.view!.center = finalPoint },
                       completion: nil)
    }
    
    func moveTheView(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        if let recognizerView = recognizer.view {
            recognizerView.center = CGPoint(x: recognizerView.center.x + translation.x,
                                            y: recognizerView.center.y)
        }
        recognizer.setTranslation(.zero, in: self)
    }
    
    func isEnoughSpeedToRecognizePan(recognizer: UIPanGestureRecognizer) -> Bool {
        let velocity = recognizer.velocity(in: self)
        let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
        guard velocity.x < 0 && magnitude > 700 else {
            return false
        }
        return true
    }
    
    func subscribeToSendTap() {
        
        topView.sendTapped
            .receive(on: DispatchQueue.main)
            .mapError({ _ in TranslationError.impossible})
            .flatMap(maxPublishers: .max(1)) { text -> AnyPublisher<String, TranslationError> in
                self.bottomView.setTypingMode()
                return self.viewModel!.manager.translate(self.topView.translationType, text: text)
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { (value) in
            switch value {
            case .failure:
                break
            case .finished:
                break
            }
        }, receiveValue: { translation in
            self.bottomView.textField.text = translation
        })
            .store(in: &subscriptions)
        
        
        bottomView.sendTapped
            .receive(on: DispatchQueue.main)
            .mapError({ _ in TranslationError.impossible})
            .flatMap(maxPublishers: .max(1)) { text -> AnyPublisher<String, TranslationError> in
                self.topView.setTypingMode()
                return self.viewModel!.manager.translate(self.bottomView.translationType, text: text)
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { (value) in
            switch value {
            case .failure:
                break
            case .finished:
                break
            }
        }, receiveValue: { translation in
            self.topView.textField.text = translation
        })
            .store(in: &subscriptions)
    }
    
    func subscribeToClearTap() {
        topView.clearTapped.sink { _ in
            self.bottomView.setDefaultMode()
            self.bottomView.textField.endEditing(true)
        }
        .store(in: &subscriptions)
        bottomView.sendTapped.sink { _ in
            self.topView.setDefaultMode()
            self.topView.textField.endEditing(true)
        }
        .store(in: &subscriptions)
    }
    
    func subscribeToRecordTap() {
        topView.recordTapped
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.topView.setTypingMode()
                self.topView.textField.becomeFirstResponder()
        }
        .store(in: &subscriptions)
        
        bottomView.recordTapped
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.bottomView.setTypingMode()
                self.bottomView.textField.becomeFirstResponder()
        }
        .store(in: &subscriptions)
    }
    
    func subscribeToMicroTap() {
        topView.microTapped
            .receive(on: DispatchQueue.main)
            .sink { _ in
                print("top micro tapped")
                self.bottomView.setDefaultMode()
        }
        .store(in: &subscriptions)
        
        bottomView.microTapped
            .receive(on: DispatchQueue.main)
            .sink { _ in
                print("bottom micro tapped")
                self.topView.setDefaultMode()
        }
        .store(in: &subscriptions)
    }
}

