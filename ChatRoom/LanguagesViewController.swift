//
//  LanguagesViewController.swift
//  ChatRoom
//
//  Created by Alex on 04.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit
import Combine

class LanguagesViewController: UIViewController {

    
    var inputGroup: InputViewPair?
    let factory = LanguagesVCFactory()
    var subscriptions = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViews()

    }
    
    func loadViews() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
    }
    
    func swipeToChat(translationType: TranslationType) {
        let vc = ChatRoomViewController(ChatRoomViewModel(), inputBar: MessageInputView(translationType))
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        inputGroup = factory.makeInputGroup(forView: self.view)
        inputGroup?.swipeMade
            .sink { translationType in
                self.swipeToChat(translationType: translationType)
        }
        .store(in: &subscriptions)
        view.addSubview(inputGroup!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touch registered")
        //self.view.becomeFirstResponder()
        UIApplication.shared.sendAction(#selector(TranslationInputView.setDefaultMode), to: nil, from: nil, for: nil)
    }
    
     
}


class LanguagesVCFactory {
    func makeInputGroup(forView view: UIView) -> InputViewPair {
        let inputGroup = InputViewPair(InputPairViewModel(YandexTranslator()))
        var insets = view.safeAreaInsets
        if insets.bottom == 0 {
            insets.bottom = 16
        } else {
            insets.bottom = 0
        }
        inputGroup.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 2 * 44 + 40)
        inputGroup.center = CGPoint(x: inputGroup.bounds.size.width/2.0, y: inputGroup.bounds.height/2.0 + insets.top + 15)
        return inputGroup
    }
}
