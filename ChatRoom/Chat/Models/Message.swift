//
//  Message.swift
//  ChatRoom
//
//  Created by Alex on 01.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

struct Message: Codable {
    let message: String
    let senderUsername: String
    var messageSender: MessageSender
    var translatedMessage: String
    //private var manager = APIManager()
    
    init(message: String, translatedMessage: String = "", messageSender: MessageSender, username: String) {
        self.message = message.withoutWhitespace()
        self.messageSender = messageSender
        self.senderUsername = username
        self.translatedMessage = translatedMessage
    }
    

}

extension String {
    func withoutWhitespace() -> String {
        return self.replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "\0", with: "")
            .replacingOccurrences(of: "\t", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
    }
    
    func isEmpty() -> Bool {
        let range = NSRange(location: 0, length: self.utf16.count)
        let regex = try! NSRegularExpression(pattern: "^(?!\\s*$).+")
        if regex.firstMatch(in: self, options: [], range: range) != nil {
            return false
        } else {
            return true
        }
    }
}
