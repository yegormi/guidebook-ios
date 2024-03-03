//
//  RequestError.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//

import Foundation

enum RequestError: String, Equatable {
    case userNotFound // signin email
    case invalidPassword // signin password
    case usernameNotUnique // signup username
    case emailNotUnique // signup email
    case tokenExpired // token expired
    case tokenInvalid // token invalid
    case guideNotFound // guide not found

    var code: String {
        switch self {
        case .userNotFound:
            "user-not-found"
        case .invalidPassword:
            "invalid-password"
        case .usernameNotUnique:
            "username-not-unique"
        case .emailNotUnique:
            "email-not-unique"
        case .tokenExpired:
            "jwt-expired"
        case .tokenInvalid:
            "jwt-invalid"
        case .guideNotFound:
            "guide-not-found"
        }
    }

    var string: String {
        switch self {
        case .userNotFound:
            "User not found"
        case .invalidPassword:
            "Invalid password"
        case .usernameNotUnique:
            "Username is not unique"
        case .emailNotUnique:
            "Email is not unique"
        case .tokenExpired:
            "Token expired"
        case .tokenInvalid:
            "Token invalid"
        case .guideNotFound:
            "Guide is not found"
        }
    }
}
