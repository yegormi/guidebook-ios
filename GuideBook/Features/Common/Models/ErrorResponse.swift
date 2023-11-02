//
//  ErrorResponse.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 27.10.2023.
//

import Foundation

struct ErrorResponse: Codable, Equatable, Error {
    let code: String
    let message: String
}
