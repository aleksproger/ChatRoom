//
//  InputView.swift
//  ChatRoom
//
//  Created by Alex on 05.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit
import Combine

protocol INView {
    func setTypingMode(_ text: String)
    func setDefaultMode()
    func setRecordingMode()
    
    var clearButton: UIButton! { set get }
    var sendButton: UIButton! { set get }
    var recordButton: UIButton! { set get }
    var micButton: UIButton { set get }
    var flagsView: UIView! { set get }
    var shadows: UIView { get }
    var shapes: UIView { get }
    
    var textField: UITextField { get }
    
    var factory: Factory { get }
    
    var translationType: TranslationType { get }
    
    
    var subscriptions: Set<AnyCancellable> { get set }
    var sendTapped: PassthroughSubject<String, Never> { get set }
    var clearTapped: PassthroughSubject<Bool, Never> { get set }
    var recordTapped: PassthroughSubject<Bool, Never> { get set }
    var microTapped: PassthroughSubject<Bool, Never> { get set }
    
}

extension INView where Self: UIView {
    
    func setRecordingMode() {
        self.clearButton.isHidden = true
        self.sendButton.isHidden = true
        self.micButton.isHidden = true
        self.recordButton.isHidden = false
        self.textField.text = "Говорите..."
    }
    
    func setTypingMode(_ text: String = "") {
        textField.becomeFirstResponder()
        textField.text = text
        textField.alpha = 1
        micButton.isHidden = true
        sendButton.isHidden = false
        clearButton.isHidden = false
        recordButton.isHidden = true
    }
    
    func setShape() {
        shapes.frame = bounds
        shapes.center = CGPoint(x: frame.size.width/2.0 , y: shapes.bounds.size.height/2.0)
        shapes.backgroundColor = .white
        shapes.layer.cornerRadius = 22
        switch translationType {
        case .engToRus:
            shapes.layer.backgroundColor = Constants.messageBlueColor.cgColor
        case .rusToEng:
            shapes.layer.backgroundColor = Constants.messageRedColor.cgColor
        }
        
    }
    
    func setShadows() {
        shadows.frame = bounds
        shadows.center = CGPoint(x: frame.size.width/2.0 , y: shadows.bounds.size.height/2.0)
        shadows.layer.bounds = shadows.bounds
        shadows.layer.position = shadows.center
        let shadowPath = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 22)
        shadows.layer.shadowPath = shadowPath.cgPath
        shadows.layer.shadowOpacity = 1
        shadows.layer.shadowRadius = 12
        shadows.layer.shadowOffset = CGSize(width: 0, height: 8)
        switch translationType {
        case .engToRus:
            shadows.layer.shadowColor = Constants.blueShadowColor
        case .rusToEng:
            shadows.layer.shadowColor = Constants.redShadowColor
            
        }
    }
    
    func makeTextFieldView() {
        //62 from right 56 from left
        textField.frame = CGRect(x: 0, y: 0, width: bounds.width - 62 - 56, height: 20.0)
        textField.center = CGPoint(x: bounds.minX + 56 + textField.bounds.width/2.0, y: bounds.height/2.0)
        textField.textColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        textField.font = UIFont(name: Constants.chatFont, size: Constants.placeholderFontSize)
        textField.alpha = 0.8
        textField.autocorrectionType = .no
        textField.clearsOnInsertion = true
        textField.tintColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        switch translationType {
        case .engToRus:
            textField.text = "Английский"
        case .rusToEng:
            textField.text = "Русский"
        }
    }
    
}
