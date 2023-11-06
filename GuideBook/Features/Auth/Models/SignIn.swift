//
//  SignInRequest.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 06.11.2023.
//

import Foundation

struct SignInRequest: Codable {
    let email: String
    let password: String
}
