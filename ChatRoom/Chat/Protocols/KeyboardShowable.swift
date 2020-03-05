//
//  KeyboardShowable.swift
//  ChatRoom
//
//  Created by Alex on 05.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit
protocol KeyboardShowable {
    func keyboardWillChange(notification: Notification)
    func animateKeyboardAppearance(point: CGPoint, inset: UIEdgeInsets)
    func processKeyboardNotification(_ notification: Notification) -> CGRect?
}

extension KeyboardShowable where Self: ChatRoom {
    func keyboardWillChange(notification: Notification) {
            keyboardIsShown.toggle()
            guard let endFrame = processKeyboardNotification(notification) else {
                return
            }
            let messageBarHeight = messageInputBar.bounds.size.height
            var insets = view.safeAreaInsets
            // To make inpit view 16px higher of phone frame when device lower than iphone X
            if insets.bottom == 0 {
                insets.bottom = 16
            }
            let point = CGPoint(x: self.messageInputBar.center.x, y: endFrame.origin.y - messageBarHeight/2.0 - (keyboardIsShown ? 16 : insets.bottom))
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
        
        func processKeyboardNotification(_ notification: Notification) -> CGRect? {
            guard let userInfo = notification.userInfo else {
                return nil
            }
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue
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
}
