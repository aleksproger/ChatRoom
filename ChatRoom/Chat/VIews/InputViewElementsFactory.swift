//
//  InputViewElementsFactory.swift
//  ChatRoom
//
//  Created by Alex on 18.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

class Factory {
    func makeFlagsView(_ translationType: TranslationType, forView view: UIView) -> UIView{
        let rusImageView = UIImageView(image: UIImage(named: "rus"))
        let engImageView = UIImageView(image: UIImage(named: "eng"))
        let imagesContainerView = UIView()
        
        imagesContainerView.layer.cornerRadius = 18
        imagesContainerView.frame = CGRect(x: 0, y: 0, width: 46, height: 36)
        imagesContainerView.center = CGPoint(x: view.bounds.minX + 4 + 23, y: view.bounds.size.height/2.0)
        
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
            rusImageView.center = CGPoint(x: view.bounds.minX + 2 + 16 + 10, y: imagesContainerView.bounds.size.height/2.0)
            engImageView.center = CGPoint(x: view.bounds.minX + 2 + 16 , y: imagesContainerView.bounds.size.height/2.0)
            imagesContainerView.backgroundColor = .white
            imagesContainerView.addSubview(rusImageView)
            imagesContainerView.addSubview(engImageView)
        case .rusToEng:
            rusImageView.center = CGPoint(x: view.bounds.minX + 2 + 16 + 10, y: imagesContainerView.bounds.size.height/2.0)
            engImageView.center = CGPoint(x: view.bounds.minX + 2 + 16, y: imagesContainerView.bounds.size.height/2.0)
            imagesContainerView.backgroundColor = .white
            imagesContainerView.addSubview(engImageView)
            imagesContainerView.addSubview(rusImageView)
        }
        
        return imagesContainerView
    }
    
    func makeShadowView(forView view: TranslationInputView) -> UIView {
        let shadows = UIView()
        shadows.frame = view.bounds
        shadows.center = CGPoint(x: view.frame.size.width/2.0 , y: shadows.bounds.size.height/2.0)
        shadows.layer.bounds = shadows.bounds
        shadows.layer.position = shadows.center
        let shadowPath = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 22)
        shadows.layer.shadowPath = shadowPath.cgPath
        shadows.layer.shadowOpacity = 1
        shadows.layer.shadowRadius = 12
        shadows.layer.shadowOffset = CGSize(width: 0, height: 8)
        switch view.translationType {
        case .engToRus:
            shadows.layer.shadowColor = Constants.blueShadowColor
        case .rusToEng:
            shadows.layer.shadowColor = Constants.redShadowColor
        case .none:
            break
        }
        
        return shadows
    }
    
    func makeSendButton(forView view: UIView) -> UIButton {
        let sendButton = UIButton()
        sendButton.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        sendButton.center = CGPoint(x: view.bounds.maxX - 14 - sendButton.bounds.width/2.0, y: view.bounds.height/2.0)
        sendButton.setImage(UIImage(named: "send"), for: .normal)
        sendButton.isHidden = true
        return sendButton
    }
    
    func makeClearButton(forView view: UIView) -> UIButton {
        let clearButton = UIButton()
        clearButton.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        clearButton.center = CGPoint(x: view.bounds.maxX - 46 - clearButton.bounds.width/2.0, y: view.bounds.height/2.0)
        clearButton.setImage(UIImage(named: "clear"), for: .normal)
        clearButton.isHidden = true
        return clearButton
    }
    
    func makeMicButton(forView view: UIView) -> UIButton {
        let micButton = UIButton()
        micButton.frame = CGRect(x: 0, y: 0, width: 12, height: 16)
        micButton.center = CGPoint(x: view.bounds.maxX - 16 - micButton.bounds.width/2.0, y: view.bounds.height/2.0)
        micButton.setImage(UIImage(named: "micro")!, for: .normal)
        return micButton
    }
    
    func makeRecordButton(forView view: UIView) -> UIButton {
        let recordButton = UIButton()
        recordButton.frame = CGRect(x: 0, y: 0, width: 18, height: 16)
        recordButton.center = CGPoint(x: view.bounds.maxX - 16 - recordButton.bounds.width/2.0, y: view.bounds.height/2.0)
        recordButton.setImage(UIImage(named: "record"), for: .normal)
        recordButton.isHidden = true
        return recordButton
    }
    
    func makeTextField(forView view: TranslationInputView) -> UITextField {
        let textField = UITextField()
        textField.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 62 - 56, height: 20.0)
        textField.center = CGPoint(x: view.bounds.minX + 56 + textField.bounds.width/2.0, y: view.bounds.height/2.0)
        textField.textColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        textField.font = UIFont(name: Constants.chatFont, size: Constants.placeholderFontSize)
        textField.alpha = 0.8
        textField.autocorrectionType = .no
        textField.clearsOnInsertion = true
        textField.tintColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        switch view.translationType {
        case .engToRus:
            textField.text = "Английский"
        case .rusToEng:
            textField.text = "Русский"
        case .none:
            break
        }
        return textField
    }
    
    func makeTextField(for bounds: CGRect, with translationType: TranslationType) -> UITextField {
        let textField = UITextField()
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
        return textField
    }
}
