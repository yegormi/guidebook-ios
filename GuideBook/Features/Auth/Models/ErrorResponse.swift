//
//  ErrorResponse.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 06.11.2023.
//

import Foundation

struct ErrorResponse: Codable, Equatable, Error {
    let code: String
    let message: String
}
