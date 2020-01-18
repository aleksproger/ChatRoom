//
//  ViewController.swift
//  ChatRoom
//
//  Created by Alex on 01.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

struct OutputMessage: Codable {
    var text: String
    var type: TranslationType
    var username: String
}

protocol ChatServiceDelegate {
    func receiveMessage(_ notification: Notification)
}

class ChatRoomViewController: UIViewController {
    private var keyboardIsShown: Bool = false
    private var lastContentOffset: CGFloat = 0
    private var currentContentInset: UIEdgeInsets = .zero
    private var viewModel = ChatRoomViewModel()
    //private let chatService = ChatService()
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
    
    var messages: [Message] = [
        Message(message: "Looooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong message!", messageSender: .ourself, username: "Alex"),
        Message(message: "Tell me how to get to the library?", messageSender: .somebody, username: "Nick"),
        Message(message: "Hello", messageSender: .somebody, username: "Nick"),
        Message(message: "Hello2", messageSender: .somebody, username: "Nick"),
        Message(message: "Hello", messageSender: .somebody, username: "Nick"),
        Message(message: "Hi", messageSender: .ourself, username: "Alex"),
        Message(message: "Hello2", messageSender: .somebody, username: "Nick"),
        Message(message: "Hello", messageSender: .somebody, username: "Nick"),
        Message(message: "Hello2", messageSender: .somebody, username: "Nick"),
        Message(message: "Hello2", messageSender: .somebody, username: "Nick"),
        Message(message: "Hello", messageSender: .somebody, username: "Nick"),
        Message(message: "Hello2", messageSender: .somebody, username: "Nick"),
        Message(message: "Hello", messageSender: .somebody, username: "Nick"),
        Message(message: "Hi", messageSender: .ourself, username: "Alex"),
        Message(message: "Hello2", messageSender: .somebody, username: "Nick"),
        Message(message: "Hello", messageSender: .somebody, username: "Nick"),
        Message(message: "Hello2", messageSender: .somebody, username: "Nick"),
        Message(message: "Hello", messageSender: .somebody, username: "Nick"),
        Message(message: "Hi", messageSender: .ourself, username: "Alex"),
        Message(message: "Nick has joined", messageSender: .somebody, username: "Nick"),
        Message(message: "Alex has joined", messageSender: .somebody, username: "Alex")]
    
}

extension ChatRoomViewController /*UITableViewDelegate, UITableViewDataSource*/ {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messages.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = MessageTableViewCell(style: .default, reuseIdentifier: "MessageCell")
//        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
//        cell.selectionStyle = .none
//        let message = messages[indexPath.row]
//        cell.apply(message: message)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let height = MessageTableViewCell.height(for: messages[indexPath.row])
//        return height
//    }
//
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        UIApplication.shared.sendAction(#selector(MessageInputView.setDefaultMode), to: nil, from: nil, for: nil)
//    }
//
//    func insertNewMessageCell(_ message: Message) {
//        messages.insert(message, at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        tableView.beginUpdates()
//        tableView.insertRows(at: [indexPath], with: .top)
//        tableView.endUpdates()
//        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
//    }
    
    func insertNewMessageCell(_ message: Message) {
        viewModel.insertMessage(message)
        tableView.beginUpdates()
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .top)
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    /*func scrollViewDidScroll(_ scrollView: UIScrollView) {
     var emptySpaceHeight: CGFloat = 0
     var y: CGFloat = scrollView.contentSize.height - Constants.footerHeight
     if (self.lastContentOffset > scrollView.contentOffset.y) {
     if scrollView.contentSize.height - Constants.footerHeight < scrollView.contentOffset.y {
     tableView.tableFooterView?.isHidden = true
     }
     /*if let lastRow = tableView.indexPathsForVisibleRows?.first {
     let lastRowFrame = tableView.rectForRow(at: lastRow)
     emptySpaceHeight = tableView.frame.size.height - (lastRowFrame.origin.y + lastRowFrame.size.height)
     }*/
     // move up
     }
     else if (self.lastContentOffset < scrollView.contentOffset.y) {
     if scrollView.contentSize.height - Constants.footerHeight >= scrollView.contentOffset.y {
     y = scrollView.contentOffset.y + (tableView.frame.height - Constants.footerHeight) - emptySpaceHeight
     }
     tableView.tableFooterView?.isHidden = false
     // move down
     }
     
     // update the new position acquired
     self.lastContentOffset = scrollView.contentOffset.y
     //let y = Constants.footerHeight + (scrollView.contentOffset.y - Constants.footerHeight) + 414.0
     //let y = scrollView.contentOffset.y + (tableView.frame.height - Constants.footerHeight)
     print(scrollView.contentOffset.y)
     let height: CGFloat = 52.0
     tableView.tableFooterView?.frame = CGRect(x: 0, y: y
     , width: UIScreen.main.bounds.size.width, height: height)
     }*/
    
    
}

extension ChatRoomViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sendMessage(_ :)), name: Constants.msgSendTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveMessage(_:)), name: Constants.msgReceived, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveJoinMessage(_:)), name: Constants.joinMsgReceived, object: nil)
        self.view.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(swipeBack(recognizer:))))
        //ChatService.shared.writeMessage("Zdarova")
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
        let safeArea = view.safeAreaLayoutGuide
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue
            print(endFrame.minY, safeArea.layoutFrame.maxY)
            if keyboardIsShown &&  (safeArea.layoutFrame.maxY <= endFrame.minY) {
                keyboardIsShown = false
            } else if !keyboardIsShown && (safeArea.layoutFrame.maxY > endFrame.minY) {
                keyboardIsShown = true
            }
            let messageBarHeight = self.messageInputBar.bounds.size.height
            var insets = view.safeAreaInsets
            if insets.bottom == 0 {
                insets.bottom = 16
            }
            
            let point = CGPoint(x: self.messageInputBar.center.x, y: endFrame.origin.y - messageBarHeight/2.0 - (keyboardIsShown ? 16 : insets.bottom))
            print(insets.bottom)
            let inset = UIEdgeInsets(top: (keyboardIsShown ? (endFrame.size.height - insets.bottom + 16) : 0), left: 0, bottom: 0, right: 0)
            print(inset)
            UIView.animate(withDuration: 0.25) {
                self.messageInputBar.center = point
                self.tableView.contentInset = inset
                if self.tableView.numberOfSections != 0 && self.tableView.numberOfRows(inSection: 0) != 0  && self.tableView.contentInset.top != 0{
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: false)
                }
            }
            
        }
    }
    
    /* @objc func microButtonTapped() {
     /*messageInputBar.clearButton.isHidden = true
     messageInputBar.sendButton.isHidden = true
     messageInputBar.micButton.isHidden = true
     messageInputBar.recordButton.isHidden = false
     messageInputBar.textField.text = "Говорите..."*/
     messageInputBar.viewModel?.microButtonTapped()
     }
     
     @objc func recordButtonTapped() {
     messageInputBar.clearButton.isHidden = true
     messageInputBar.sendButton.isHidden = true
     messageInputBar.micButton.isHidden = false
     messageInputBar.recordButton.isHidden = true
     messageInputBar.textField.text = "Английский"
     }
     
     @objc func clearButtonTapped() {
     messageInputBar.textField.text = ""
     }*/
    
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
