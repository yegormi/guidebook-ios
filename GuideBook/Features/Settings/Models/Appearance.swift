//
//  Appearance.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 25.10.2023.
//

import Foundation

enum Appearance: String, CaseIterable, Identifiable, Codable {
    case light, auto, dark
    var id: Self { self }

    var modeImage: String {
        switch self {
        case .light:
            "sun.max"
        case .auto:
            "character"
        case .dark:
            "moon.fill"
        }
    }
}
