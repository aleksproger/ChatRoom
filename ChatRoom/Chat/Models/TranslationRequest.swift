//
//  TranslationRequest.swift
//  ChatRoom
//
//  Created by Alex on 07.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

struct TranslationRequest: Codable {
    let code: Int
    let lang: String
    let text: [String]
    
}
