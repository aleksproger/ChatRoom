//
//  Label.swift
//  ChatRoom
//
//  Created by Alex on 02.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

class MessageLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
      let insets = UIEdgeInsets.init(top: 8, left: 16, bottom: 8, right: 16)
      super.drawText(in: rect.inset(by: insets))
    }
    
    /*var textInsets = UIEdgeInsets.zero {
            didSet { invalidateIntrinsicContentSize() }
        }

        override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
            let insetRect = bounds.inset(by: textInsets)
            let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
            let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                    left: -textInsets.left,
                    bottom: -textInsets.bottom,
                    right: -textInsets.right)
            return textRect.inset(by: invertedInsets)
        }

        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.inset(by: textInsets))
        }
    }

    extension Label {
        var leftTextInset: CGFloat {
            set { textInsets.left = newValue }
            get { return textInsets.left }
        }

        var rightTextInset: CGFloat {
            set { textInsets.right = newValue }
            get { return textInsets.right }
        }

        var topTextInset: CGFloat {
            set { textInsets.top = newValue }
            get { return textInsets.top }
        }

        var bottomTextInset: CGFloat {
            set { textInsets.bottom = newValue }
            get { return textInsets.bottom }
        }*/
}