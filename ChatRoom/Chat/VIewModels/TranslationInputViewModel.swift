//
//  TranslationInputViewModel.swift
//  ChatRoom
//
//  Created by Alex on 05.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

//
//  MessageInputViewModel.swift
//  ChatRoom
//
//  Created by Alex on 04.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit
import Combine

class TranslationInputViewModel: NSObject, MessageInputDelegate {
    private weak var view: MessageInputView?
    init(_ view: MessageInputView) {
        self.view = view
    }
    @objc func microButtonTapped() {
        view?.clearButton.isHidden = true
        view?.sendButton.isHidden = true
        view?.micButton.isHidden = true
        view?.recordButton.isHidden = false
        view?.textField.text = "Говорите..."
    }
    
    @objc func recordButtonTapped() {
        view?.clearButton.isHidden = true
        view?.sendButton.isHidden = true
        view?.micButton.isHidden = false
        view?.recordButton.isHidden = true
        view?.textField.text = "Английский"
    }
    
    @objc func clearButtonTapped() {
        NotificationCenter.default.post(name: Constants.clearTapped, object: self, userInfo: ["id" : view!.translationType])
        view?.textField.text = ""
        view?.textField.becomeFirstResponder()
    }
    
    @objc func sendButtonTapped() {
        NotificationCenter.default.post(name: Constants.sendTapped, object: self, userInfo: ["id" : view!.translationType])
    }
    
}

extension TranslationInputViewModel: UITextFieldDelegate {
    
    func setTypingMode() {
        view?.textField.text = ""
        view?.textField.alpha = 1
        view?.micButton.isHidden = true
        view?.sendButton.isHidden = false
        view?.clearButton.isHidden = false
        view?.recordButton.isHidden = true
    }
    
    func setDefaultMode() {
        guard let view = view else {
            return
        }
        view.textField.alpha = 0.8
        view.micButton.isHidden = false
        view.sendButton.isHidden = true
        view.clearButton.isHidden = true
        view.recordButton.isHidden = true
        switch view.translationType {
        case .engToRus:
            view.textField.text = "Английский"
        case .rusToEng:
            view.textField.text = "Русский"
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //NotificationCenter.default.post(name: Constants.didBeginEditing, object: self, userInfo: ["id" : view!.translationType])
        setTypingMode()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //NotificationCenter.default.post(name: Constants.shouldReturn, object: self, userInfo: ["id" : view!.translationType])
        setDefaultMode()
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setDefaultMode()
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("Post notification and text \(string)")
        //NotificationCenter.default.post(name: Constants.changeCharacter, object: self, userInfo: ["id" : view!.translationType, "char" : string])
        return true
    }
}
