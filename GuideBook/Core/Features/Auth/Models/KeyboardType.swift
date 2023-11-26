//
//  KeyboardType.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 05.11.2023.
//

import UIKit

enum KeyboardType {
    case username, email, password

    var type: UIKeyboardType {
        switch self {
        case .username:
            return .default
        case .email:
            return .emailAddress
        case .password:
            return .asciiCapable
        }
    }
}
