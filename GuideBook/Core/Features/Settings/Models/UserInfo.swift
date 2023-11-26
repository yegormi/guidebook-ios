//
//  SelfInfo.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//

import Foundation

struct UserInfo: Codable, Equatable {
    let id: String
    let username: String
    let email: String
}
