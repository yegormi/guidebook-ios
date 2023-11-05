//
//  InputFieldStyle.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 05.11.2023.
//

import SwiftUI

struct InputFieldStyle: ViewModifier {
    let keyboard: KeyboardType
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 10)
            .font(.system(size: 17))
            .keyboardType(keyboard.type)
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
}
