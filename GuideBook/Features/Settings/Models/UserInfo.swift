//
//  SelfInfo.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//

import Foundation

struct UserInfo: Decodable, Equatable {
    let id: String
    let username: String
    let email: String
}
