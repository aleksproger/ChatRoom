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
    func setDefaultMode()
    //func sendButtonTapped()
}

protocol InputView {
    var viewModel: MessageInputDelegate? { get set }
    var translationType: TranslationType { get }
}

enum TranslationType {
    case engToRus
    case rusToEng
}

enum InputType {
    case message
    case translation
}

class MessageInputView: UIView, InputView {
    var viewModel: MessageInputDelegate?
    var text: String = "Английский"
    private var shadows = UIView()
    private var shapes = UIView()
    
    private var rusImageView = UIImageView(image: UIImage(named: "rus"))
    private var engImageView = UIImageView(image: UIImage(named: "eng"))
    private var imagesContainerView = UIView()
    
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
            self.viewModel = MessageInputViewModel(self)
        case .translation:
            self.viewModel = TranslationInputViewModel(self)
        }
        
        micButton.addTarget(viewModel, action: #selector(viewModel?.microButtonTapped), for: .touchUpInside)
        recordButton.addTarget(viewModel, action: #selector(viewModel?.recordButtonTapped), for: .touchUpInside)
        clearButton.addTarget(viewModel, action: #selector(viewModel?.clearButtonTapped), for: .touchUpInside)
        sendButton.addTarget(viewModel, action: #selector(viewModel?.sendButtonTapped), for: .touchUpInside)
        self.textField.delegate = viewModel as? UITextFieldDelegate
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        shadows.translatesAutoresizingMaskIntoConstraints = false
        shapes.translatesAutoresizingMaskIntoConstraints = false
        shapes.clipsToBounds = true
        shadows.clipsToBounds = false
        
        addSubview(shadows)
        addSubview(shapes)
        
        addSubview(textField)
        
        micButton.setImage(UIImage(named: "micro")!, for: .normal)
        addSubview(micButton)
        
        
        sendButton.setImage(UIImage(named: "send"), for: .normal)
        sendButton.isHidden = true
        addSubview(sendButton)
        
        clearButton.setImage(UIImage(named: "clear"), for: .normal)
        clearButton.isHidden = true
        addSubview(clearButton)
        
        recordButton.setImage(UIImage(named: "record"), for: .normal)
        recordButton.isHidden = true
        addSubview(recordButton)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addFlagsView()
        
        setShadows()
        setShape()
        
        makeFlagsView()
        makeTextFieldView()

        
        micButton.frame = CGRect(x: 0, y: 0, width: 12, height: 16)
        micButton.center = CGPoint(x: bounds.maxX - 16 - micButton.bounds.width/2.0, y: bounds.height/2.0)
        
        sendButton.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        sendButton.center = CGPoint(x: bounds.maxX - 14 - sendButton.bounds.width/2.0, y: bounds.height/2.0)
        
        clearButton.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        clearButton.center = CGPoint(x: bounds.maxX - 46 - clearButton.bounds.width/2.0, y: bounds.height/2.0)
        
        recordButton.frame = CGRect(x: 0, y: 0, width: 18, height: 16)
        recordButton.center = CGPoint(x: bounds.maxX - 16 - recordButton.bounds.width/2.0, y: bounds.height/2.0)
        
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
    
    func makeFlagsView() {
        imagesContainerView.layer.cornerRadius = 18
        imagesContainerView.frame = CGRect(x: 0, y: 0, width: 46, height: 36)
        imagesContainerView.center = CGPoint(x: bounds.minX + 4 + 23, y: bounds.size.height/2.0)
        
        rusImageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        rusImageView.layer.borderWidth = 1.0
        rusImageView.layer.cornerRadius = 16
        rusImageView.layer.borderColor = UIColor.white.cgColor

        engImageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        engImageView.layer.borderWidth = 1.0
        engImageView.layer.cornerRadius = 16
        engImageView.layer.borderColor = UIColor.white.cgColor

        switch translationType {
            case .engToRus:
                rusImageView.center = CGPoint(x: bounds.minX + 2 + 16 + 10, y: imagesContainerView.bounds.size.height/2.0)
                engImageView.center = CGPoint(x: bounds.minX + 2 + 16 , y: imagesContainerView.bounds.size.height/2.0)
            case .rusToEng:
                rusImageView.center = CGPoint(x: bounds.minX + 2 + 16 + 10, y: imagesContainerView.bounds.size.height/2.0)
                engImageView.center = CGPoint(x: bounds.minX + 2 + 16, y: imagesContainerView.bounds.size.height/2.0)
        }
    }
    
    func addFlagsView() {
        switch translationType {
            case .engToRus:
                print("in engtorus")
                imagesContainerView.backgroundColor = .white
                imagesContainerView.addSubview(rusImageView)
                imagesContainerView.addSubview(engImageView)
                addSubview(imagesContainerView)
            case .rusToEng:
                print("in rus to eng")
                imagesContainerView.backgroundColor = .white
                imagesContainerView.addSubview(engImageView)
                imagesContainerView.addSubview(rusImageView)
                addSubview(imagesContainerView)
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

