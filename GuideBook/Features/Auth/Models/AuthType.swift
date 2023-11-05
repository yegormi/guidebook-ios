//
//  AuthType.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 06.11.2023.
//

import Foundation

enum AuthType {
    case signIn, signUp
    
    var text: String {
        switch self {
        case .signIn:
            return "Sign in"
        case .signUp:
            return "Sign up"
        }
    }
}
