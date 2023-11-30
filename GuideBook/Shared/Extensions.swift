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
    
    func scaleButton() -> some View {
        self.buttonStyle(ScaleButtonStyle())
    }
}


extension UIDevice {
    var hasNotch: Bool {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return false }
        
        return window.safeAreaInsets.top > 20
    }
}

extension NSLayoutConstraint {
    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)"
    }
}

extension Binding where Value: Equatable {
    func removeDuplicates() -> Self {
        .init(
            get: { self.wrappedValue },
            set: { newValue, transaction in
                guard newValue != self.wrappedValue else { return }
                self.transaction(transaction).wrappedValue = newValue
            }
        )
    }
}
