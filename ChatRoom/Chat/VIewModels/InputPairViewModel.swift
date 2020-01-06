//
//  InputPairViewModel.swift
//  ChatRoom
//
//  Created by Alex on 05.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

class InputPairViewModel: NSObject {
    private weak var view: InputViewPair?
    
    init(_ view: InputViewPair) {
        super.init()
        self.view = view
        //NotificationCenter.default.addObserver(self, selector: #selector(didBeginEditingTextField(_:)), name: Constants.didBeginEditing, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(changeCharacterTextField(_:)), name: Constants.changeCharacter, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sendTapped(_:)), name: Constants.sendTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearTapped(_:)), name: Constants.clearTapped, object: nil)
        view.bottomView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:))))
        view.topView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:))))
        //view.topView.addGestureRecognizer(UISwipeGestureRecognizer())
        
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        
        let velocity = recognizer.velocity(in: self.view)
        let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
        guard velocity.x < 0 && magnitude > 700 else {
            return
        }
        print(magnitude)
        let translation = recognizer.translation(in: self.view)
        if let recognizerView = recognizer.view {
            recognizerView.center = CGPoint(x: recognizerView.center.x + translation.x,
                                  y: recognizerView.center.y)
        }
        recognizer.setTranslation(.zero, in: self.view)
        
    
        if recognizer.state == UIGestureRecognizer.State.ended {
            NotificationCenter.default.post(name: Constants.chatSegue, object: nil, userInfo: ["id" : (recognizer.view as! InputView).translationType])
            UIView.animate(withDuration: 1) {
                recognizer.view?.center.x = (self.view!.center.x)
            }
            
        } else {
            let velocity = recognizer.velocity(in: self.view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 100
            print("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
            
            // 2
            let slideFactor = 0.1 * slideMultiplier
            let finalPoint = CGPoint(x: view!.center.x,
                                     y: recognizer.view!.center.y)
            UIView.animate(withDuration: Double(slideFactor * 0.25),
                           delay: 0,
                           // 6
                options: UIView.AnimationOptions.curveEaseOut,
                animations: {recognizer.view!.center = finalPoint },
                completion: nil)
        }
        
        /*if recognizer.state == UIGestureRecognizer.State.ended {
         // 1
         let velocity = recognizer.velocity(in: self.view)
         let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
         let slideMultiplier = magnitude / 100
         print("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
         
         // 2
         let slideFactor = 0.1 * slideMultiplier     //Increase for more of a slide
         // 3
         var finalPoint = CGPoint(x:recognizer.view!.center.x + (velocity.x * slideFactor),
         y:recognizer.view!.center.y)
         // 4
         finalPoint.x = min(max(finalPoint.x, 0), (self.view?.bounds.size.width)!)
         
         // 5
         UIView.animate(withDuration: Double(slideFactor * 0.5),
         delay: 0,
         // 6
         options: UIView.AnimationOptions.curveEaseOut,
         animations: {recognizer.view!.center = finalPoint },
         completion: { _ in
         NotificationCenter.default.post(name: Constants.chatSegue, object: nil)
         })
         }*/
    }
    
    @objc func sendTapped(_ notification: Notification) {
        if let data = notification.userInfo as? [String : TranslationType], let id = data["id"] {
            if id == .engToRus {
                view?.bottomView.viewModel?.setTypingMode()
                view?.bottomView.textField.text = view?.topView.textField.text
                
            } else {
                view?.topView.viewModel?.setTypingMode()
                view?.topView.textField.text = view?.bottomView.textField.text
                
                
            }
        }
    }
    
    @objc func clearTapped(_ notification: Notification) {
        if let data = notification.userInfo as? [String : TranslationType], let id = data["id"] {
            if id == .engToRus {
                view?.bottomView.viewModel?.setDefaultMode()
                view?.bottomView.textField.endEditing(true)
                
                //view?.bottomView.textField.text = ""
                
            } else {
                view?.topView.viewModel?.setDefaultMode()
                view?.topView.textField.endEditing(true)
                
                //view?.topView.textField.text = ""
                
                
            }
        }
    }
    
    /*@objc func didBeginEditingTextField(_ notification: Notification) {
     if let data = notification.userInfo as? [String : TranslationType], let id = data["id"] {
     if id == .engToRus {
     view?.bottomView.viewModel?.setTypingMode()
     view?.topView.viewModel?.setDefaultMode()
     
     } else {
     view?.bottomView.viewModel?.setDefaultMode()
     view?.topView.viewModel?.setTypingMode()
     
     
     }
     }
     }
     
     @objc func changeCharacterTextField(_ notification: Notification) {
     guard let view = view else {
     return
     }
     if let data = notification.userInfo as? [String : Any], let id = data["id"] as? TranslationType, let char = data["char"] as? String {
     if id == .engToRus {
     view.bottomView.textField.text! += char
     } else {
     view.topView.textField.text! += char
     }
     }
     }
     
     @objc func shouldReturnTextField(_ notification: Notification) {
     if let data = notification.userInfo as? [String : TranslationType], let id = data["id"] {
     if id == .engToRus {
     view?.bottomView.viewModel?.setDefaultMode()
     } else {
     view?.topView.viewModel?.setDefaultMode()
     }
     }
     }
     */
    
}

