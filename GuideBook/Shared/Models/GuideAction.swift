//
//  GuideAction.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 30.11.2023.
//

import Foundation

enum GuideAction: Equatable {
    case getDetails(for: Guide)
    case getSteps(for: Guide)
}
