//
//  MessageTableViewCell.swift
//  ChatRoom
//
//  Created by Alex on 01.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit
enum MessageSender {
    case ourself
    case somebody
}


class MessageTableViewCell: UITableViewCell {
    
    var messageSender: MessageSender = .somebody
    let messageLabel = Label()
    let nameLabel = UILabel()
    private var isJoinMessage = false
    
    func apply(message: Message) {
        nameLabel.text = message.senderUsername
        var messageText: NSMutableAttributedString
        if !isJoinMessage(text: message.message) {
            isJoinMessage = false
            messageText = NSMutableAttributedString.init(string: (message.translatedMessage + "\n" + message.message))
            messageText.setAttributes([NSAttributedString.Key.font: UIFont(name: Constants.chatFont, size: Constants.messageFontSize)!,
                                       NSAttributedString.Key.foregroundColor: UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)], range: NSMakeRange(message.translatedMessage.count + 1, message.message.count))
            
            messageText.setAttributes([NSAttributedString.Key.font: UIFont(name: Constants.chatFont, size: 15)!,
                                       NSAttributedString.Key.foregroundColor: UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 0.8)], range: NSMakeRange(0, message.translatedMessage.count))
        } else {
            isJoinMessage = true
            messageText = NSMutableAttributedString.init(string: (message.message))
            messageText.setAttributes([NSAttributedString.Key.font: UIFont(name: Constants.chatFont, size: 15)!,
                                       NSAttributedString.Key.foregroundColor: UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 0.8)], range: NSMakeRange(0, message.message.count))
        }
        print(NSMakeRange(message.translatedMessage.count, messageText.string.count))

        messageLabel.attributedText = messageText
        messageSender = message.messageSender
        //translationLabel.text = message.translatedMessage
        setNeedsLayout()
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        messageLabel.clipsToBounds = true
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        
        
        nameLabel.textColor = .lightGray
        nameLabel.font = UIFont(name: Constants.chatFont, size: Constants.nameFontSize)
        
        clipsToBounds = true
        
        addSubview(messageLabel)
        addSubview(nameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MessageTableViewCell {
    func roundCorners(messageSender: MessageSender) {
        switch messageSender {
        case .ourself:
            messageLabel.layer.cornerRadius = min(messageLabel.bounds.size.height/3.0, 20)
            messageLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        case .somebody:
            messageLabel.layer.cornerRadius = min(messageLabel.bounds.size.height/3.0, 20)
            messageLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    // MARK: - If the string has whitespaces and has joined in the and then join message (meesage string contains no whitespaces)
    func isJoinMessage(text: String) -> Bool {
         let words = text.components(separatedBy: " ")
            if words.count >= 2 && words[words.count - 2] == "has" && words[words.count - 1] == "joined" {
                return true
            }
        
        return false
    }
    
    func layoutForJoinMessage() {
        messageLabel.font = UIFont.systemFont(ofSize: 18)
        messageLabel.textColor = .lightGray
        messageLabel.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
        
        // MARK: - Set max posssible size of label
        let size = messageLabel.sizeThatFits(CGSize(width: 2*bounds.size.width/3, height: CGFloat.greatestFiniteMagnitude))
        messageLabel.frame = CGRect(x: 0, y: 0, width: size.width + 32, height: size.height + 16)
        
        // MARK: - bounds.size.height realtively to cell size
        messageLabel.center = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2.0)
        messageLabel.textAlignment = .center
    }
    
    func layoutForMyMessage() {
       // print("In ourself layout")
        nameLabel.isHidden = true
        messageLabel.center = CGPoint(x: bounds.size.width - messageLabel.frame.width/2 - 16, y: bounds.size.height/2)
         //messageLabel.backgroundColor = Constants.messageRedColor
        if GlobalVariables.reversedColors {
            messageLabel.backgroundColor = Constants.messageBlueColor
        } else {
            messageLabel.backgroundColor = Constants.messageRedColor
        }
    }
    
    func layoutForSomebodyMessage() {
        //print("In somebody layout")
        nameLabel.isHidden = false
        nameLabel.sizeToFit()
        nameLabel.center = CGPoint(x: nameLabel.bounds.size.width/2.0 + 16 + 4, y: nameLabel.bounds.size.height/2.0 + 4)
        messageLabel.center = CGPoint(x: messageLabel.frame.size.width/2 + 16, y: messageLabel.bounds.size.height/2.0 + nameLabel.bounds.size.height + 8)
         //messageLabel.backgroundColor = Constants.messageBlueColor
        if GlobalVariables.reversedColors {
            messageLabel.backgroundColor = Constants.messageRedColor
        } else {
            messageLabel.backgroundColor = Constants.messageBlueColor
        }
        
    }
    
    // MARK: - Called through setNeedsLayout()
    override func layoutSubviews() {
        super.layoutSubviews()
        //print("In messageCell layout")
        //messageLabel.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        if isJoinMessage {
            layoutForJoinMessage()
            messageLabel.layer.cornerRadius = min(messageLabel.bounds.size.height/2.0, 20)
        } else {
            let size = messageLabel.sizeThatFits(CGSize(width:2*bounds.size.width/3, height: CGFloat.greatestFiniteMagnitude))
            messageLabel.frame = CGRect(x: 0, y: 0, width: size.width + 32, height: size.height + 16 )
            if case .ourself = messageSender {
                messageLabel.textAlignment = .right
                layoutForMyMessage()
                roundCorners(messageSender: .ourself)
            } else {
                messageLabel.textAlignment = .left
                layoutForSomebodyMessage()
                roundCorners(messageSender: .somebody)
            }
        }
    }
    
}

// MARK: - Methods that will be called from tableView(heightForRowAt:)
extension MessageTableViewCell {
    
    class func height(for message: Message) -> CGFloat {
        let maxSize = CGSize(width: 2*(UIScreen.main.bounds.size.width/3), height: CGFloat.greatestFiniteMagnitude)
        let nameHeight = message.messageSender == .ourself ? 0 : height(for: message.senderUsername, fontSize: Constants.nameFontSize, maxSize: maxSize)
        let messageHeight = height(for: message.message, fontSize: Constants.messageFontSize, maxSize: maxSize)
        let translatedMessageHeight = height(for: message.translatedMessage, fontSize:  Constants.messageFontSize, maxSize: maxSize)
        return nameHeight + messageHeight + translatedMessageHeight + 32 + 16
    }
    
    private class func height(for text: String, fontSize: CGFloat, maxSize: CGSize) -> CGFloat {
        let font = UIFont(name: Constants.chatFont, size: fontSize)!
        let attrString = NSAttributedString(string: text, attributes:[NSAttributedString.Key.font: font,
                                                                      NSAttributedString.Key.foregroundColor: UIColor.white])
        let textHeight = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size.height
        
        return textHeight
    }
    
    
}
