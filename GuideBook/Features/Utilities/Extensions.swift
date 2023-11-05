//
//  Extensions.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 30.10.2023.
//

import SwiftUI

extension UIDevice {
    var hasNotch: Bool {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return false }

        return window.safeAreaInsets.top > 20
    }
}

public extension NSLayoutConstraint {
    override var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" // you may print whatever you want here
    }
}
