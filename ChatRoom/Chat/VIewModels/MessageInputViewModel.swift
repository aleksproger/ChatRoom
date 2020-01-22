//
//  MessageInputViewModel.swift
//  ChatRoom
//
//  Created by Alex on 04.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit
import Combine
import Speech


class MessageInputViewModel: NSObject{
    
    private var speechRecognition: Recognition!
    init( recognizer: Recognition) {
        self.speechRecognition = recognizer
    }
}

