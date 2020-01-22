//
//  InputPairViewModel.swift
//  ChatRoom
//
//  Created by Alex on 05.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit
import Combine

class InputPairViewModel: NSObject {
    var manager: Translator
    init(_ manager: Translator) {
        self.manager = manager
    }
}

