//
//  SignUpRequest.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 28.10.2023.
//

import Foundation

struct SignUpRequest: Codable {
    let username: String
    let email: String
    let password: String
}
