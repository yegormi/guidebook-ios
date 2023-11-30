//
//  GuideDetails.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 30.11.2023.
//

import Foundation

struct GuideDetails: Codable, Equatable {
    let id: String
    let emoji: String
    let title: String
    let description: String
    let image: String
    let authorId: String
    let author: Author
    let isFavorite: Bool
}

struct Author: Codable, Equatable {
    let username: String
}
