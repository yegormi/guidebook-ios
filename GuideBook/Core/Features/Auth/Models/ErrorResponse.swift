//
//  ErrorResponse.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 06.11.2023.
//

import Foundation

enum ErrorResponse: Error {
    case networkError(Error)
    case decodingError(Error)
    case failedWithResponse(FailResponse)
}
