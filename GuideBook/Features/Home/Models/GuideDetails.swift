//
//  GuideDetails.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
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
}

struct Author: Codable {
    let username: String
}
