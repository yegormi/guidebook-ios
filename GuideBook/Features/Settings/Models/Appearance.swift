//
//  Appearance.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//

import Foundation

enum Appearance: String, CaseIterable, Identifiable, Codable {
    case light, auto, dark
    var id: Self { self }

    var modeImage: String {
        switch self {
        case .light:
            return "sun.max"
        case .auto:
            return "character"
        case .dark:
            return "moon.fill"
        }
    }
}
