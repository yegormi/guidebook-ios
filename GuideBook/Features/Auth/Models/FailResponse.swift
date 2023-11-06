//
//  FailResponse.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 06.11.2023.
//

import Foundation

struct FailResponse: Decodable, Equatable {
    let code: String
    let message: String
}
