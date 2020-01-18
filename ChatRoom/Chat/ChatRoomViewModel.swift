//
//  ChatRoomDelegate.swift
//  ChatRoom
//
//  Created by Alex on 18.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

class ChatRoomViewModel: NSObject, UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageTableViewCell(style: .default, reuseIdentifier: "MessageCell")
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        cell.selectionStyle = .none
        let message = messages[indexPath.row]
        cell.apply(message: message)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = MessageTableViewCell.height(for: messages[indexPath.row])
        return height
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIApplication.shared.sendAction(#selector(MessageInputView.setDefaultMode), to: nil, from: nil, for: nil)
    }
    
    func insertMessage(_ message: Message) {
        messages.insert(message, at: 0)
    }
}
