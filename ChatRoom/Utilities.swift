//
//  Utilities.swift
//  ChatRoom
//
//  Created by Alex on 01.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let nameFontSize: CGFloat = 15.0
    static let messageFontSize: CGFloat = 20.0
    static let placeholderFontSize: CGFloat = 17.0
    static let chatFont: String = "YandexSansText-Medium"
    static let footerHeight: CGFloat = 80.0
    static let messageRedColor: UIColor = UIColor(red: 0.929, green: 0.298, blue: 0.361, alpha: 1)
    static let messageBlueColor: UIColor = UIColor(red: 0, green: 0.486, blue: 0.914, alpha: 1)
    static let blueShadowColor = UIColor(red: 0, green: 0.482, blue: 0.945, alpha: 0.3).cgColor
    static let redShadowColor  = UIColor(red: 1, green: 0.22, blue: 0.341, alpha: 0.3).cgColor
    static let didBeginEditing = Notification.Name("didBeginEditing")
    static let shouldReturn = Notification.Name("shouldReturn")
    static let changeCharacter = Notification.Name("changeCharacter")
    static let sendTapped = Notification.Name("sendTapped")
    static let clearTapped = Notification.Name("clearTapped")
    static let chatSegue = Notification.Name("chatSegue")
    static let msgSendTapped = Notification.Name("msgSendTapped")
    static let msgReceived = Notification.Name("msgReceived")
    static let joinMsgReceived = Notification.Name("joinMsgReceived")
    
    static let engRusColors = ["ourself" : messageBlueColor, "somebody" : messageRedColor]
    static let rusEngColors = ["ourself" : messageRedColor, "somebody" : messageBlueColor]

}

struct GlobalVariables {
    static var reversedColors: Bool = false
}
