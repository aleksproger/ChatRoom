//
//  ChatRoomDelegate.swift
//  ChatRoom
//
//  Created by Alex on 18.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit
import Combine

class ChatRoomViewModel: NSObject, ObservableObject {
    var messages = CurrentValueSubject<[Message], Never>([
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
        Message(message: "Alex has joined", messageSender: .somebody, username: "Alex")])
    
    func insertMessage(_ message: Message) {
        print("inserting message")
        var newMessages = messages.value
        newMessages.insert(message, at: 0)
        messages.send(newMessages)
    }
}


extension ChatRoomViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.value.count

    }
}

extension ChatRoomViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageTableViewCell(style: .default, reuseIdentifier: "MessageCell")
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        cell.selectionStyle = .none
        let message = messages.value[indexPath.row]
        cell.apply(message: message)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = MessageTableViewCell.height(for: messages.value[indexPath.row])
        return height
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIApplication.shared.sendAction(#selector(MessageInputView.setDefaultMode), to: nil, from: nil, for: nil)
    }
    
}

extension ChatRoomViewModel: ChatServiceDelegate {
    func receiveJoinMessage(message: String) {
        if message.withoutWhitespace() != "" {
            let message = Message(message: message, messageSender: .somebody, username: "System")
            DispatchQueue.main.async {
                self.insertMessage(message)
            }
        }
    }
    
    func receiveMessage(message: Message) {
        if message.message != "" {
            DispatchQueue.main.async {
                self.insertMessage(message)
            }
        }
    }
    
    func sendMessage(message: String, translationType: TranslationType) {
        if message.withoutWhitespace() != "" {
            //ChatService.shared.writeMessage(message.message)
            //insertNewMessageCell(Message(message: "lol", messageSender: .ourself, username: "Alex"))
            ChatService.shared.sendMessaage(OutputMessage(text: message, type: translationType, username: "Alex"))
        }
    }
}
