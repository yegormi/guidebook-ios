//
//  AuthTitle.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 06.11.2023.
//

import SwiftUI

struct AuthTitle: View {
    let authType: AuthType
    
    var body: some View {
        Text(authType.text)
            .font(.system(size: 36))
            .transition(
                .scale(scale: 0.01, anchor: .center)
                .combined(with: .opacity)
                .animation(.easeInOut)
            )
    }
}
