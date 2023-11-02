//
//  RequestError.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 31.10.2023.
//

import Foundation

enum RequestError: String, Equatable {
    case userNotFound = "user-not-found"           // signin email
    case emailNotUnique = "email-not-unique"       // signup email
    case invalidPassword = "invalid-password"      // signin password
    case usernameNotUnique = "username-not-unique" // signup username
    case tokenExpired = "jwt-expired"
    case tokenInvalid = "jwt-indalid"
    case guideNotFound = "guide-not-found"
}

