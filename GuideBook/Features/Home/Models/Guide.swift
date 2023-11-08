//
//  Guide.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//

import Foundation

struct Guide: Codable, Equatable, Identifiable {
    let id: String
    let title: String
    let description: String
    let emoji: String
}
