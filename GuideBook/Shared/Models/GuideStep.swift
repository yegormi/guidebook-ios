//
//  GuideStep.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 30.11.2023.
//

import Foundation

struct GuideStep: Codable, Equatable {
    let id: String
    let title: String
    let description: String
    let image: String
    let order: Int
    let guideId: String
}
