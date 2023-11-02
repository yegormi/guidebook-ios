//
//  Guide.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 25.10.2023.
//

import Foundation

struct Guide: Identifiable, Equatable, Codable {
    let id: String
    let title: String
    let description: String
    let emoji: String
}
