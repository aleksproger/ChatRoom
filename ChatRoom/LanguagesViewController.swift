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
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(swipeToChat(_ :)), name: Constants.chatSegue, object: nil)
        loadViews()

    }
    
    func loadViews() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
    }
    
    @objc func swipeToChat(_ notification: Notification) {
        print("In segue")
        if let data = notification.userInfo as? [String : TranslationType], let id = data["id"] {
            let vc = ChatRoomViewController(MessageInputView(id, type: .message))
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func swipeToEngRusChat() {
        print("in swipe")
        let vc = ChatRoomViewController(MessageInputView(.engToRus, type: .message))
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func swipeToRusEngChat() {
        print("in swipe")
        let vc = ChatRoomViewController(MessageInputView(.rusToEng, type: .message))
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        inputGroup = factory.makeInputGroup(forView: self.view)
        view.addSubview(inputGroup!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touch registered")
        UIApplication.shared.sendAction(#selector(MessageInputView.setDefaultMode), to: nil, from: nil, for: nil)
    }
    
     
}


class LanguagesVCFactory {
    func makeInputGroup(forView view: UIView) -> InputViewPair {
        let inputGroup = InputViewPair()
        var insets = view.safeAreaInsets
        if insets.bottom == 0 {
            insets.bottom = 16
        } else {
            insets.bottom = 0
        }
//        print(insets.top)
        inputGroup.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 2 * 44 + 40)
        inputGroup.center = CGPoint(x: inputGroup.bounds.size.width/2.0, y: inputGroup.bounds.height/2.0 + insets.top + 15)
        return inputGroup
    }
}
