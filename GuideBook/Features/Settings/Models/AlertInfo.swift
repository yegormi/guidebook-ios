//
//  AlertInfo.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 30.10.2023.
//

import Foundation

struct AlertInfo: Identifiable {
    var id = UUID()
    let title: String
    let description: String
}
