//
//  InputViewPair.swift
//  ChatRoom
//
//  Created by Alex on 04.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class InputViewPair: UIView {

    private(set) var topView = MessageInputView(.engToRus, type: .translation)
    private(set) var bottomView = MessageInputView(.rusToEng, type: .translation)
    var viewModel: InputPairViewModel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.viewModel = InputPairViewModel(self)
        addSubview(topView)
        addSubview(bottomView)
    }
    
    override func layoutSubviews() {
        let insets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        topView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: 44)
        topView.frame = topView.frame.inset(by: insets)
        bottomView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: 44)
        bottomView.frame = bottomView.frame.inset(by: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4))
        bottomView.center = CGPoint(x: bounds.size.width/2.0, y: bounds.size.height/2.0 + 44)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

