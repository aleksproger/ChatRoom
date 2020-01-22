//
//  TranslationError.swift
//  ChatRoom
//
//  Created by Alex on 21.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

enum TranslationError: Error {
    case network(description: String)
    case speech(description: String)
    case impossible
}
