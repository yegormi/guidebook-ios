//
//  ScaleButtonStyle.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 30.11.2023.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    public init() {}
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .brightness(configuration.isPressed ? -0.1 : 0)
            .animation(.linear(duration: 0.2), value: configuration.isPressed)
    }
}
