//
//  GuideStep.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//

import Foundation

struct GuideStep: Codable {
    let id: String
    let title: String
    let description: String
    let image: String
    let order: Int
    let guideId: String
}
