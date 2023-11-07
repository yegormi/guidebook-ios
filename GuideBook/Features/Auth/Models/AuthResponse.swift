//
//  AuthResponse.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 06.11.2023.
//

import Foundation

struct AuthResponse: Decodable, Equatable {
    let accessToken: String
}
