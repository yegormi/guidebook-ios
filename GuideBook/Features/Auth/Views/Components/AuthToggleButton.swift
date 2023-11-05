//
//  AuthToggleButton.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 06.11.2023.
//

import SwiftUI

struct AuthToggleButton: View {
    let authType: AuthType
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            Text(authType == .signIn ? "Don't have an account?" : "Already have an account?")
                .padding([.bottom, .top, .leading], 20)
            Text(authType == .signIn ? "Sign up" : "Sign in")
                .foregroundStyle(.blue)
                .padding([.bottom, .top, .trailing], 20)
                .onTapGesture {
                    onTap()
                }
        }
    }
}
