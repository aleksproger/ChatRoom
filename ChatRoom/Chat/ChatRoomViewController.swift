//
//  ViewController.swift
//  ChatRoom
//
//  Created by Alex on 01.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit



protocol ChatServiceDelegate {
    func receiveMessage(_ notification: Notification)
}

class ChatRoomViewController: UIViewController {
    private var keyboardIsShown: Bool = false
    private var lastContentOffset: CGFloat = 0
    private var currentContentInset: UIEdgeInsets = .zero
    private var viewModel = ChatRoomViewModel()
    var tableView = UITableView()
    var messageInputBar = MessageInputView(.engToRus, type: .message)
    
    init(_ inputBar: MessageInputView, chatService: ChatService = ChatService.shared) {
        self.messageInputBar = inputBar
        if inputBar.translationType == .rusToEng {
            GlobalVariables.reversedColors = true
        } else {
            GlobalVariables.reversedColors = false
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func insertNewMessageCell(_ message: Message) {
        viewModel.insertMessage(message)
        tableView.beginUpdates()
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .top)
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    
}


extension ChatRoomViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sendMessage(_ :)), name: Constants.msgSendTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveMessage(_:)), name: Constants.msgReceived, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveJoinMessage(_:)), name: Constants.joinMsgReceived, object: nil)
        self.view.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(swipeBack(recognizer:))))
        ChatService.shared.joinChat(username: "Alex")
        loadViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if self.tableView.numberOfSections != 0 && self.tableView.numberOfRows(inSection: 0) != 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: false)
        }
    }
    
    @objc func swipeBack(recognizer: UISwipeGestureRecognizer) {
        if recognizer.direction == .right {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        keyboardIsShown.toggle()
        print("now keyboard is", keyboardIsShown)
        guard let endFrame = processKeyboardNotification(notification) else {
            return
        }
        let messageBarHeight = self.messageInputBar.bounds.size.height
        var insets = view.safeAreaInsets
        // To make inpit view 16px higher of phone frame when device lower than iphone X
        if insets.bottom == 0 {
            insets.bottom = 16
        }
        let point = CGPoint(x: self.messageInputBar.center.x, y: endFrame.origin.y - messageBarHeight/2.0 - (keyboardIsShown ? 16 : insets.bottom))
        print(insets.bottom)
        let inset = UIEdgeInsets(top: (keyboardIsShown ? (endFrame.size.height - insets.bottom + 16) : 0), left: 0, bottom: 0, right: 0)
        animateKeyboardAppearance(point: point, inset: inset)
        
    }
    
    func animateKeyboardAppearance(point: CGPoint, inset: UIEdgeInsets) {
        UIView.animate(withDuration: 0.25) {
            self.messageInputBar.center = point
            self.tableView.contentInset = inset
            if self.tableView.numberOfSections != 0 && self.tableView.numberOfRows(inSection: 0) != 0  && self.tableView.contentInset.top != 0{
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: false)
            }
        }
    }
    
    func processKeyboardNotification(_ notification: NSNotification) -> CGRect? {
        guard let userInfo = notification.userInfo else {
            return nil
        }
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue
        //print(endFrame.minY, safeArea.layoutFrame.maxY)
        keyboardIsShown = isKeyboardReallyShown(keyboardFrame: endFrame)
        return endFrame
        
    }
    
    func isKeyboardReallyShown(keyboardFrame: CGRect) -> Bool {
        let safeArea = view.safeAreaLayoutGuide
        if keyboardIsShown &&  (safeArea.layoutFrame.maxY <= keyboardFrame.minY) {
            return false
        } else if !keyboardIsShown && (safeArea.layoutFrame.maxY > keyboardFrame.minY) {
            return true
        }
        
        return keyboardIsShown
    }

    // Adding new views to ierarchy and give content to existing
    func loadViews() {
        navigationController?.navigationBar.isHidden = true
        navigationItem.title = "Chat"
        navigationItem.backBarButtonItem?.title = "Run"
        view.backgroundColor = .white
        //view.backgroundColor = UIColor(red: 24/255, green: 180/255, blue: 128/255, alpha: 1.0)
        
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        tableView.separatorStyle = .none
        /* let footer = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: Constants.footerHeight))
         print(footer.frame.size)
         footer.transform = CGAffineTransform(scaleX: 1, y: -1)
         footer.textLabel?.font = UIFont.boldSystemFont(ofSize: 40)
         footer.textLabel?.textColor = .black
         footer.textLabel?.text = "Яндекс Переводчик"
         footer.textLabel?.textAlignment = .center
         footer.textLabel?.backgroundColor = .white
         footer.backgroundColor = .lightGray
         tableView.tableFooterView = footer*/
        tableView.showsVerticalScrollIndicator = false
        tableView.transform = CGAffineTransform(scaleX: 1,y: -1)
        tableView.keyboardDismissMode = .onDrag
        view.addSubview(tableView)
        view.addSubview(messageInputBar)
        
        
        
    }
    
    // Set frames and mb constraints for views in this function
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let safeSize = view.safeAreaLayoutGuide.layoutFrame.size
        let size = view.bounds.size
        var insets = view.safeAreaInsets
        let messageBarHeight:CGFloat = 44.0
        if insets.bottom == 0 {
            insets.bottom = 16
        } else {
            insets.bottom = 0
        }
        tableView.frame = CGRect(x: 0, y: insets.top, width: size.width, height: safeSize.height - messageBarHeight + 8 - insets.bottom)
        messageInputBar.frame = CGRect(x: 4, y: insets.top + tableView.frame.size.height - 8, width: size.width - 8, height: messageBarHeight)
    }
}

extension ChatRoomViewController: ChatServiceDelegate {
    @objc func receiveMessage(_ notification: Notification) {
        if let data = notification.userInfo as? [String : Message], let message = data["message"] {
            //let message = Message(message: text, messageSender: .ourself, username: "Alex")
            if message.message != "" {
                self.insertNewMessageCell(message)
            }
        }
    }
    
    @objc func receiveJoinMessage(_ notification: Notification) {
        if let data = notification.userInfo as? [String : String], let msg = data["text"] {
            //let message = Message(message: text, messageSender: .ourself, username: "Alex")
            if msg.withoutWhitespace() != "" {
                let message = Message(message: msg, messageSender: .somebody, username: "System")
                DispatchQueue.main.async {
                    self.insertNewMessageCell(message)
                }
            }
        }
    }
    
    @objc func sendMessage(_ notification: Notification) {
        if let data = notification.userInfo as? [String : Any], let text = data["text"] as? String {
            //let message = Message(message: text, messageSender: .ourself, username: "Alex")
            if text.withoutWhitespace() != "" {
                //self.insertNewMessageCell(message)
                
                //ChatService.shared.writeMessage(message.message)
                ChatService.shared.sendMessaage(OutputMessage(text: text, type: messageInputBar.translationType, username: "Alex"))
            }
        }
    }
    
}
