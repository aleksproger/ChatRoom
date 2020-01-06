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

class MessageInputViewModel: NSObject, MessageInputDelegate {
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
        view?.textField.text = ""
    }
    
    @objc func sendButtonTapped() {

    }
    
}

extension MessageInputViewModel: UITextFieldDelegate {
    
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
        setTypingMode()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        setDefaultMode()
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setDefaultMode()
        textField.resignFirstResponder()
    }
    
}
