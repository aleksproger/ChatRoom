////
////  ViewController.swift
////  ChatRoom
////
////  Created by Alex on 01.01.2020.
////  Copyright © 2020 Alex. All rights reserved.
////
//
//import UIKit
//import Combine
//
//protocol ChatServiceDelegate {
//    func receiveMessage(message: Message)
//    func receiveJoinMessage(message: String)
//    func sendMessage(message: String, translationType: TranslationType)
//}
//
//protocol ChatRoom: UIViewController {
//    var keyboardIsShown: Bool { get set }
//    var messageInputBar: MessageInputView! { get set }
//    var tableView: UITableView { get set }
//}
//
//
//class ChatRoomViewController: UIViewController, ChatRoom {
//
//    internal var keyboardIsShown: Bool = false
//    private var lastContentOffset: CGFloat = 0
//    private var currentContentInset: UIEdgeInsets = .zero
//    private var viewModel = ChatRoomViewModel()
//    private var subscriptions = Set<AnyCancellable>()
//    var tableView: UITableView = UITableView()
//    var messageInputBar: MessageInputView!
//
//    init(_ inputBar: MessageInputView, tableView: UITableView) {
//        super.init(nibName: nil, bundle: nil)
//        self.messageInputBar = inputBar
//        //self.tableView = tableView
//        GlobalVariables.reversedColors = inputBar.translationType == .rusToEng ? true : false
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        subscribeToSend()
//        subscribeToChatService()
//        subscribeToMessageSource()
//        NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification).sink { (notification) in
//            self.keyboardWillChange(notification: notification)
//        }
//        .store(in: &subscriptions)
//        ChatService.shared.joinChat(username: "Alex")
//        loadViews()
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        if self.tableView.numberOfSections != 0 && self.tableView.numberOfRows(inSection: 0) != 0 {
//            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: false)
//        }
//    }
//
//    // Set frames and mb constraints for views in this function
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        self.view.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(swipeBack(recognizer:))))
//        let safeSize = view.safeAreaLayoutGuide.layoutFrame.size
//        let size = view.bounds.size
//        var insets = view.safeAreaInsets
//        let messageBarHeight:CGFloat = 44.0
//        if insets.bottom == 0 {
//            insets.bottom = 16
//        } else {
//            insets.bottom = 0
//        }
//        tableView.frame = CGRect(x: 0, y: insets.top, width: size.width, height: safeSize.height - messageBarHeight + 8 - insets.bottom)
//        messageInputBar.frame = CGRect(x: 4, y: insets.top + tableView.frame.size.height - 8, width: size.width - 8, height: messageBarHeight)
//    }
//
//
//
//
//}
//
//
//extension ChatRoomViewController {
//    func subscribeToSend() {
//        messageInputBar.sendTapped
//            .sink { text in
//                print("in send button sink")
//                self.viewModel.sendMessage(message: text, translationType: self.messageInputBar.translationType)
//        }
//        .store(in: &subscriptions)
//    }
//
//    func subscribeToMessageSource() {
//        viewModel.messages
//            .handleEvents(receiveOutput: { messages in
//                print("in sink")
//                self.updateTableView()
//        })
//        .ignoreOutput()
//        .sink { (_) in}
//        .store(in: &subscriptions)
//
//    }
//
//    func subscribeToChatService() {
//        ChatService.shared.messageReceived
//            .sink { message in
//                self.viewModel.receiveMessage(message: message)
//        }
//        .store(in: &subscriptions)
//
//        ChatService.shared.joinMessageReceived
//            .sink { text in
//                self.viewModel.receiveJoinMessage(message: text)
//        }
//        .store(in: &subscriptions)
//
//    }
//
//    func insertNewMessageCell(_ message: Message) {
//        viewModel.insertMessage(message)
//        tableView.beginUpdates()
//        let indexPath = IndexPath(row: 0, section: 0)
//        tableView.insertRows(at: [indexPath], with: .top)
//        tableView.endUpdates()
//        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
//    }
//
//    func updateTableView() {
//        tableView.beginUpdates()
//        let indexPath = IndexPath(row: 0, section: 0)
//        tableView.insertRows(at: [indexPath], with: .top)
//        tableView.endUpdates()
//        if tableView.numberOfRows(inSection: 0) > 0 {
//            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
//        }
//    }
//
//    func loadViews() {
//        navigationController?.navigationBar.isHidden = true
//        navigationItem.title = "Chat"
//        navigationItem.backBarButtonItem?.title = "Run"
//        view.backgroundColor = .white
//        //view.backgroundColor = UIColor(red: 24/255, green: 180/255, blue: 128/255, alpha: 1.0)
//
//        tableView.dataSource = viewModel
//        tableView.delegate = viewModel
//        tableView.separatorStyle = .none
//        /* let footer = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: Constants.footerHeight))
//         print(footer.frame.size)
//         footer.transform = CGAffineTransform(scaleX: 1, y: -1)
//         footer.textLabel?.font = UIFont.boldSystemFont(ofSize: 40)
//         footer.textLabel?.textColor = .black
//         footer.textLabel?.text = "Яндекс Переводчик"
//         footer.textLabel?.textAlignment = .center
//         footer.textLabel?.backgroundColor = .white
//         footer.backgroundColor = .lightGray
//         tableView.tableFooterView = footer*/
//        tableView.showsVerticalScrollIndicator = false
//        tableView.transform = CGAffineTransform(scaleX: 1,y: -1)
//        tableView.keyboardDismissMode = .onDrag
//        view.addSubview(tableView)
//        view.addSubview(messageInputBar)
//    }
//
//
//    @objc func swipeBack(recognizer: UISwipeGestureRecognizer) {
//        if recognizer.direction == .right {
//            self.navigationController?.popViewController(animated: true)
//        }
//    }
//
//}
//
//extension ChatRoomViewController: KeyboardShowable {}
import UIKit
import Combine

protocol ChatRoom: UIViewController {
    var keyboardIsShown: Bool { get set }
    var messageInputBar: MessageInputView! { get set }
    var tableView: UITableView { get set }
}

class ChatRoomViewController: UIViewController, ChatRoom {
    var keyboardIsShown: Bool = false
    var tableView: UITableView = UITableView()
    var messageInputBar: MessageInputView! {
        willSet {
            GlobalVariables.reversedColors = newValue.translationType == .rusToEng ? true : false
        }
    }
    private var viewModel: ChatRoomViewModel!

    private var subscriptions = Set<AnyCancellable>()

    init(_ viewModel: ChatRoomViewModel, inputBar: MessageInputView) {
        super.init(nibName: nil, bundle: nil)
       self.messageInputBar = inputBar
        self.viewModel = viewModel
        //self.tableView = tableView
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToSend()
        subscribeToChatService()
        subscribeToMessageSource()
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification).sink { (notification) in
            self.keyboardWillChange(notification: notification)
        }
        .store(in: &subscriptions)
        ChatService.shared.joinChat(username: "Alex")
        loadViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if self.tableView.numberOfSections != 0 && self.tableView.numberOfRows(inSection: 0) != 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: false)
        }
    }
    
    // Set frames and mb constraints for views in this function
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(swipeBack(recognizer:))))
        let safeSize = view.safeAreaLayoutGuide.layoutFrame.size
        let size = view.bounds.size
        var insets = view.safeAreaInsets
        let messageBarHeight:CGFloat = 44.0
        insets.bottom = (insets.bottom == 0) ? 16 : 0
        tableView.frame = CGRect(x: 0, y: insets.top, width: size.width, height: safeSize.height - messageBarHeight + 8 - insets.bottom)
        messageInputBar.frame = CGRect(x: 4, y: insets.top + tableView.frame.size.height - 8, width: size.width - 8, height: messageBarHeight)
    }

}


extension ChatRoomViewController {
    func updateTableView() {
        tableView.beginUpdates()
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .top)
        tableView.endUpdates()
        if tableView.numberOfRows(inSection: 0) > 0 {
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }

    func loadViews() {
        navigationController?.navigationBar.isHidden = true
        navigationItem.title = "Chat"
        navigationItem.backBarButtonItem?.title = "Run"
        view.backgroundColor = .white
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.transform = CGAffineTransform(scaleX: 1,y: -1)
        tableView.keyboardDismissMode = .onDrag
        view.addSubview(tableView)
        view.addSubview(messageInputBar)
    }

    
    @objc func swipeBack(recognizer: UISwipeGestureRecognizer) {
        if recognizer.direction == .right {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func subscribeToSend() {
        messageInputBar.sendTapped
            .sink { text in
                print("in send button sink")
                self.viewModel.sendMessage(message: text, translationType: self.messageInputBar.translationType)
        }
        .store(in: &subscriptions)
    }
    
    func subscribeToMessageSource() {
        viewModel.messages
            .handleEvents(receiveOutput: { messages in
                print("in sink")
                self.updateTableView()
        })
        .ignoreOutput()
        .sink { _ in}
        .store(in: &subscriptions)
        
    }
    
    func subscribeToChatService() {
        ChatService.shared.messageReceived
            .sink { message in
                self.viewModel.receiveMessage(message: message)
        }
        .store(in: &subscriptions)
        
        ChatService.shared.joinMessageReceived
            .sink { text in
                self.viewModel.receiveJoinMessage(message: text)
        }
        .store(in: &subscriptions)
        
    }
    
}

extension ChatRoomViewController: KeyboardShowable {}
