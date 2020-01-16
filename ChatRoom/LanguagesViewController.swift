//
//  LanguagesViewController.swift
//  ChatRoom
//
//  Created by Alex on 04.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class LanguagesViewController: UIViewController {

    let inputGroup0 = InputViewPair()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(swipeToChat(_ :)), name: Constants.chatSegue, object: nil)
        loadViews()
        //manager.translate(.rusToEng, text: "Thing")
        // Do any additional setup after loading the view.
    }
    
    func loadViews() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        view.addSubview(inputGroup0)
    }
    
    @objc func swipeToChat(_ notification: Notification) {
        print("In segue")
        if let data = notification.userInfo as? [String : TranslationType], let id = data["id"] {
            let vc = ChatRoomViewController(MessageInputView(id, type: .message))
            self.navigationController?.pushViewController(vc, animated: true)
        }

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var insets = view.safeAreaInsets
        if insets.bottom == 0 {
            insets.bottom = 16
        } else {
            insets.bottom = 0
        }
        print(insets.top)
        inputGroup0.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 2 * 44 + 40)
        inputGroup0.center = CGPoint(x: inputGroup0.bounds.size.width/2.0, y: inputGroup0.bounds.height/2.0 + insets.top + 15)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touch registered")
        UIApplication.shared.sendAction(#selector(MessageInputView.setDefaultMode), to: nil, from: nil, for: nil)
    }
    
     
}

extension UIResponder {
    func responderChain() -> String {
        guard let next = next else {
            return String(describing: self) + "NO"
        }
        return String(describing: self) + " -> " + next.responderChain()
    }
}


