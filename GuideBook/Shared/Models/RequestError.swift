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
    case tokenExpired       // token expired
    case tokenInvalid       // token invalid
    case guideNotFound      // guide not found
    
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
        case .tokenExpired:
            return "jwt-expired"
        case .tokenInvalid:
            return "jwt-invalid"
        case .guideNotFound:
            return "guide-not-found"
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
        case .tokenExpired:
            return "Token expired"
        case .tokenInvalid:
            return "Token invalid"
        case .guideNotFound:
            return "Guide is not found"
        }
    }
}
