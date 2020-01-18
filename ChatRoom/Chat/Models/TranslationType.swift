//
//  TranslationType.swift
//  ChatRoom
//
//  Created by Alex on 17.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

enum TranslationType: String, Codable {
    
    case engToRus
    case rusToEng
}

enum InputType {
    case message
    case translation
}

struct OutputMessage: Codable {
    var text: String
    var type: TranslationType
    var username: String
}
