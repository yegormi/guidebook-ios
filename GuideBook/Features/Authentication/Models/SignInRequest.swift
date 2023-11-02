//
//  SignInRequest.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 28.10.2023.
//

import Foundation

struct SignInRequest: Codable {
    let email: String
    let password: String
}
