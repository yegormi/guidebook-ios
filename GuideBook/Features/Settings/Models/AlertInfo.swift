//
//  AlertInfo.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//

import Foundation

struct AlertInfo: Identifiable {
    var id = UUID()
    let title: String
    let description: String
}
