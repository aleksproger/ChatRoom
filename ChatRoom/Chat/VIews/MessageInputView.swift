//
//  MessageInputview.swift
//  ChatRoom
//
//  Created by Alex on 03.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit
import Combine

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

//protocol InputView: UIView {
//    var clearButton: UIButton! { get set }
//    var sendButton: UIButton!  { get set }
//    var recordButton: UIButton!  { get set }
//    var flagsView: UIView!  { get set }
//}


class MessageInputView: UIView, InputView {
    
    var clearButton: UIButton!
    var sendButton: UIButton!
    var recordButton: UIButton!
    var micButton = UIButton()
    var flagsView: UIView!
    
    var shadows = UIView()
    var shapes = UIView()
    
    
    var textField = UITextField()
    let factory = Factory()
    
    var translationType: TranslationType = .rusToEng

    
    var speechRecognition = SpeechRecognition()
    var viewModel: MessageInputViewModel?
    var subscriptions = Set<AnyCancellable>()
    var sendTapped = PassthroughSubject<String, Never>()
    var clearTapped = PassthroughSubject<Bool, Never>()
    var recordTapped = PassthroughSubject<Bool, Never>()
    var microTapped = PassthroughSubject<Bool, Never>()
    var text: String = "Английский"
    
    convenience init(_ translationType: TranslationType) {
        self.init(frame: .zero)
        self.translationType = translationType
        //self.viewModel = MessageInputViewModel(recognizer: SpeechRecognition())
        self.textField.delegate = self
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
        registerButtons()
    }
    func registerButtons() {
        micButton.addTarget(self, action: #selector(microButtonTapped), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
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
    
    
    @objc func microButtonTapped() {
        setRecordingMode()
        speechRecognition.startRecording()
            .sink(receiveCompletion: { [weak self] (completion) in
            self?.speechRecognition.stopRecording()
            switch completion {
            case .finished:
                print("Finished")
            case .failure(let error):
                self?.setTypingMode()
                print(error.localizedDescription)
            }
                }, receiveValue: {
                    (translation) in
                    print(translation)
                    self.setTypingMode(translation)
                })
            .store(in: &subscriptions)
    }
    
    func setRecordingMode() {
        self.clearButton.isHidden = true
        self.sendButton.isHidden = true
        self.micButton.isHidden = true
        self.recordButton.isHidden = false
        self.textField.text = "Говорите..."
    }
    
    @objc func recordButtonTapped() {
        speechRecognition.stopRecording()
        setTypingMode()
    }
    
    @objc func clearButtonTapped() {
        textField.text = ""
    }
    
    @objc func sendButtonTapped() {
        sendTapped.send(textField.text!)
        setTypingMode()
    }
    
}


extension MessageInputView: UITextFieldDelegate {
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
