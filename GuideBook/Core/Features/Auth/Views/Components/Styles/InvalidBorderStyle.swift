//
//  Modifiers.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 05.11.2023.
//

import SwiftUI

struct InvalidBorderStyle: ViewModifier {
    let isInvalid: Bool
    
    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    isInvalid ? Color.red : Color.clear,
                    lineWidth: 2
                )
        )
    }
}
