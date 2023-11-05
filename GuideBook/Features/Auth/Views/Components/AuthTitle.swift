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
        HStack {
            Text(authType.text)
                .font(.system(size: 36))
            Spacer()
        }
        .transition(.slide.combined(with: .opacity))
    }
}
