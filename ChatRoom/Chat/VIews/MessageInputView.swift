//
//  MessageInputview.swift
//  ChatRoom
//
//  Created by Alex on 03.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

@objc protocol MessageInputDelegate {
    //func sendWasTapped(message: String)
    func microButtonTapped()
    func recordButtonTapped()
    func clearButtonTapped()
    func sendButtonTapped()
    func setTypingMode()
    //func setDefaultMode()
    //func sendButtonTapped()
}

protocol InputView: UIView {
    var viewModel: MessageInputDelegate? { get set }
    var translationType: TranslationType { get }
}


class MessageInputView: UIView, InputView {
    var viewModel: MessageInputDelegate?
    var text: String = "Английский"
    
    private let factory = Factory()
    
    private var shadows = UIView()
    private var shapes = UIView()
    
    var flagsView: UIView!
    
    var textField = UITextField()
    
    var micButton = UIButton()
    var clearButton = UIButton()
    
    var sendButton = UIButton()
    var recordButton = UIButton()
    
    private(set) var translationType: TranslationType = .rusToEng
    
    convenience init(_ translationType: TranslationType, type: InputType) {
        self.init(frame: .zero)
        self.translationType = translationType
        switch type {
        case .message:
            self.viewModel = MessageInputViewModel(self, recognizer: SpeechRecognition())
        case .translation:
            self.viewModel = TranslationInputViewModel(self)
        }
        
        self.textField.delegate = viewModel as? UITextFieldDelegate
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //shadows = factory.makeShadowView(forView: self)
        translatesAutoresizingMaskIntoConstraints = false
        shadows.translatesAutoresizingMaskIntoConstraints = false
        shapes.translatesAutoresizingMaskIntoConstraints = false
        shapes.clipsToBounds = true
        shadows.clipsToBounds = false

        addSubview(shadows)
        addSubview(shapes)
        //textField = factory.makeTextField(forView: self)
        //textField.delegate = viewModel as? UITextFieldDelegate
        addSubview(textField)
        
        micButton.setImage(UIImage(named: "micro")!, for: .normal)
        addSubview(micButton)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flagsView = factory.makeFlagsView(translationType, forView: self)
        addSubview(flagsView)

        setShadows()
        setShape()
        
        makeTextFieldView()

        
        micButton.frame = CGRect(x: 0, y: 0, width: 12, height: 16)
        micButton.center = CGPoint(x: bounds.maxX - 16 - micButton.bounds.width/2.0, y: bounds.height/2.0)
        
        sendButton = factory.makeSendButton(forView: self)
        addSubview(sendButton)
        
        clearButton = factory.makeClearButton(forView: self)
        addSubview(clearButton)
        
        recordButton = factory.makeRecordButton(forView: self)
        addSubview(recordButton)
        
//        micButton = factory.makeMicButton(forView: self)
//        addSubview(micButton)
        
        registerButtons()
        
    }
    func registerButtons() {
        micButton.addTarget(viewModel, action: #selector(viewModel?.microButtonTapped), for: .touchUpInside)
        clearButton.addTarget(viewModel, action: #selector(viewModel?.clearButtonTapped), for: .touchUpInside)
        sendButton.addTarget(viewModel, action: #selector(viewModel?.sendButtonTapped), for: .touchUpInside)
        recordButton.addTarget(viewModel, action: #selector(viewModel?.recordButtonTapped), for: .touchUpInside)
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
    
    @objc func setDefaultMode() {
        textField.resignFirstResponder()
        textField.alpha = 0.8
        micButton.isHidden = false
        sendButton.isHidden = true
        clearButton.isHidden = true
        recordButton.isHidden = true
        switch translationType {
        case .engToRus:
            textField.text = "Английский"
        case .rusToEng:
            textField.text = "Русский"
        }
    }
    
    @objc func setTypingMode() {
            textField.becomeFirstResponder()
            textField.text = ""
            textField.alpha = 1
            micButton.isHidden = true
            sendButton.isHidden = false
            clearButton.isHidden = false
            recordButton.isHidden = true
    }
    
    
}


