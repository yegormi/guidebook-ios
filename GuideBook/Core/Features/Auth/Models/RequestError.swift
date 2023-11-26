//
//  RequestError.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//

import Foundation

enum RequestError: String, Equatable {
    case userNotFound       // signin email
    case invalidPassword    // signin password
    case usernameNotUnique  // signup username
    case emailNotUnique     // signup email
    
    var code: String {
        switch self {
        case .userNotFound:
            return "user-not-found"
        case .invalidPassword:
            return "invalid-password"
        case .usernameNotUnique:
            return "username-not-unique"
        case .emailNotUnique:
            return "email-not-unique"
        }
    }
    
    var string: String {
        switch self {
        case .userNotFound:
            return "User not found"
        case .invalidPassword:
            return "Invalid password"
        case .usernameNotUnique:
            return "Username is not unique"
        case .emailNotUnique:
            return "Email is not unique"
        }
    }
}
