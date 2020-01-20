//
//  InputViewPair.swift
//  ChatRoom
//
//  Created by Alex on 04.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class InputViewPair: UIView {

    private(set) var topView = MessageInputView(.engToRus, type: .translation)
    private(set) var bottomView = MessageInputView(.rusToEng, type: .translation)
    var viewModel: InputPairViewModel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.viewModel = InputPairViewModel(self)
        addSubview(topView)
        addSubview(bottomView)
        NotificationCenter.default.addObserver(self, selector: #selector(sendTapped(_:)), name: Constants.sendTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearTapped(_:)), name: Constants.clearTapped, object: nil)
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
            let recognizerView = recognizer.view as! InputView
            print("Need transition")
            switch recognizerView.translationType {
            case .engToRus:
                print("send action")
                UIApplication.shared.sendAction(#selector(LanguagesViewController.swipeToEngRusChat), to: nil, from: nil, for: nil)
            case .rusToEng:
                print("send action")
                UIApplication.shared.sendAction(#selector(LanguagesViewController.swipeToRusEngChat), to: nil, from: nil, for: nil)
            }
            NotificationCenter.default.post(name: Constants.chatSegue, object: nil, userInfo: ["id" : (recognizer.view as! InputView).translationType])
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
        print(magnitude)
        return true
    }
    
    @objc func sendTapped(_ notification: Notification) {
        if let data = notification.userInfo as? [String : TranslationType], let id = data["id"] {
            if id == .engToRus {
                self.bottomView.viewModel?.setTypingMode()
                let textForTranslation = self.topView.textField.text ?? ""
                viewModel?.manager.translate(.engToRus, text: textForTranslation) { translation in
                    DispatchQueue.main.async {
                        self.bottomView.textField.text = translation
                    }
                }
                
            } else {
                self.topView.viewModel?.setTypingMode()
                let textForTranslation = self.bottomView.textField.text ?? ""
                viewModel?.manager.translate(.rusToEng, text: textForTranslation) { translation in
                    DispatchQueue.main.async {
                        self.topView.textField.text = translation
                    }
                    
                }
                //                view?.topView.textField.text = view?.bottomView.textField.text
                
                
            }
        }
    }
    
    @objc func clearTapped(_ notification: Notification) {
        if let data = notification.userInfo as? [String : TranslationType], let id = data["id"] {
            if id == .engToRus {
                self.bottomView.setDefaultMode()
                self.bottomView.textField.endEditing(true)
                
                //view?.bottomView.textField.text = ""
                
            } else {
                self.topView.setDefaultMode()
                self.topView.textField.endEditing(true)
                
                //view?.topView.textField.text = ""
            }
        }
    }
    
}

