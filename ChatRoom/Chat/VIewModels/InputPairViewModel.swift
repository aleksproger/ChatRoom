//
//  InputPairViewModel.swift
//  ChatRoom
//
//  Created by Alex on 05.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit
import Combine

class InputPairViewModel: NSObject {
    private weak var view: InputViewPair?
    let manager = APIManager()
    
    init(_ view: InputViewPair) {
        super.init()
//        self.view = view
//
//        NotificationCenter.default.addObserver(self, selector: #selector(sendTapped(_:)), name: Constants.sendTapped, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(clearTapped(_:)), name: Constants.clearTapped, object: nil)
//        view.bottomView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:))))
//        view.topView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:))))
        
        
    }
    
//    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
//        guard isEnoughSpeedToRecognizePan(recognizer: recognizer) else {
//            return
//        }
//        moveTheView(recognizer: recognizer)
//        
//        
//        if recognizer.state == UIGestureRecognizer.State.ended {
//            let recognizerView = recognizer.view as! InputView
//            print("Need transition")
//            switch recognizerView.translationType {
//            case .engToRus:
//                print("send action")
//                UIApplication.shared.sendAction(#selector(LanguagesViewController.swipeToEngRusChat), to: nil, from: nil, for: nil)
//            case .rusToEng:
//                print("send action")
//                UIApplication.shared.sendAction(#selector(LanguagesViewController.swipeToRusEngChat), to: nil, from: nil, for: nil)
//            }
//            NotificationCenter.default.post(name: Constants.chatSegue, object: nil, userInfo: ["id" : (recognizer.view as! InputView).translationType])
//            UIView.animate(withDuration: 1) {
//                recognizer.view?.center.x = (self.view!.center.x)
//            }
//        } else {
//            animateSlidingBack(recognizer: recognizer)
//        }
//    }
//    
//    func animateSlidingBack(recognizer: UIPanGestureRecognizer) {
//        let velocity = recognizer.velocity(in: self.view)
//        let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
//        let slideMultiplier = magnitude / 100
//        print("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
//        
//        let slideFactor = 0.1 * slideMultiplier
//        let finalPoint = CGPoint(x: view!.center.x,
//                                 y: recognizer.view!.center.y)
//        UIView.animate(withDuration: Double(slideFactor * 0.25),
//                       delay: 0,
//                       options: UIView.AnimationOptions.curveEaseOut,
//                       animations: {recognizer.view!.center = finalPoint },
//                       completion: nil)
//    }
//    
//    func moveTheView(recognizer: UIPanGestureRecognizer) {
//        let translation = recognizer.translation(in: self.view)
//        if let recognizerView = recognizer.view {
//            recognizerView.center = CGPoint(x: recognizerView.center.x + translation.x,
//                                            y: recognizerView.center.y)
//        }
//        recognizer.setTranslation(.zero, in: self.view)
//    }
//    
//    func isEnoughSpeedToRecognizePan(recognizer: UIPanGestureRecognizer) -> Bool {
//        let velocity = recognizer.velocity(in: self.view)
//        let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
//        guard velocity.x < 0 && magnitude > 700 else {
//            return false
//        }
//        print(magnitude)
//        return true
//    }
//    
//    @objc func sendTapped(_ notification: Notification) {
//        if let data = notification.userInfo as? [String : TranslationType], let id = data["id"] {
//            if id == .engToRus {
//                view?.bottomView.viewModel?.setTypingMode()
//                let textForTranslation = view?.topView.textField.text ?? ""
//                manager.translate(.engToRus, text: textForTranslation) { translation in
//                    DispatchQueue.main.async {
//                        self.view?.bottomView.textField.text = translation
//                    }
//                }
//                
//            } else {
//                view?.topView.viewModel?.setTypingMode()
//                let textForTranslation = view?.bottomView.textField.text ?? ""
//                manager.translate(.rusToEng, text: textForTranslation) { translation in
//                    DispatchQueue.main.async {
//                        self.view?.topView.textField.text = translation
//                    }
//                    
//                }
//                //                view?.topView.textField.text = view?.bottomView.textField.text
//                
//                
//            }
//        }
//    }
//    
//    @objc func clearTapped(_ notification: Notification) {
//        if let data = notification.userInfo as? [String : TranslationType], let id = data["id"] {
//            if id == .engToRus {
//                view?.bottomView.setDefaultMode()
//                view?.bottomView.textField.endEditing(true)
//                
//                //view?.bottomView.textField.text = ""
//                
//            } else {
//                view?.topView.setDefaultMode()
//                view?.topView.textField.endEditing(true)
//                
//                //view?.topView.textField.text = ""
//            }
//        }
//    }
    
}

