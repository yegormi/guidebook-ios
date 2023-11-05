//
//  Extensions.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 05.11.2023.
//

import SwiftUI

extension View {
    func invalidBorder(isActive: Bool) -> some View {
        self.modifier(InvalidBorderStyle(isInvalid: isActive))
    }
    
    func inputFieldStyle(type: KeyboardType) -> some View {
        self.modifier(InputFieldStyle(keyboard: type))
    }
}
