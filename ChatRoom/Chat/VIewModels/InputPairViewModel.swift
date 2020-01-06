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

