//
//  UserInfoResponse.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 28.10.2023.
//

import Foundation

struct UserInfoResponse: Codable {
    let id: String
    let username: String
    let email: String
}
