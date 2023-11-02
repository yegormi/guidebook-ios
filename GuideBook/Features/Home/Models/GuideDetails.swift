//
//  GuideDetails.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 28.10.2023.
//

import Foundation

struct GuideDetails: Codable {
    let id: String
    let emoji: String
    let title: String
    let description: String
    let image: String
    let authorId: String
    let author: Author
    let isFavorite: Bool

    
    enum CodingKeys: String, CodingKey {
        case id
        case emoji
        case title
        case description
        case image
        case authorId
        case author
        case isFavorite
    }
}

struct Author: Codable {
    let username: String
}
