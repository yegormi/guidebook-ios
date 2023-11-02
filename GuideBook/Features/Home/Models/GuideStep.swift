//
//  GuideStep.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 01.11.2023.
//

import Foundation

struct GuideStep: Codable {
    let id: String
    let title: String
    let description: String
    let image: String
    let order: Int
    let guideId: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case image
        case order
        case guideId
    }
}
