//
//  LoadingButtonStyle.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 28.10.2023.
//

import SwiftUI

struct LoadingButtonStyle: View {
    var isSignIn: Bool
    var isLoading: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            if !isLoading {
                action()
            }
        }) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                        .scaleEffect(1, anchor: .center)
                } else {
                    Text(isSignIn ? "SIGN IN" : "SIGN UP")
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, minHeight: 45)
                        .foregroundColor(Color.white)
                        .background(isLoading ? Color.blue.opacity(0.3) : Color.blue)
                        .cornerRadius(10)
                }
            }
        }
        .disabled(isLoading)
    }
}

struct LoadingButtonStyle_Previews: PreviewProvider {
    static var isSignIn: Bool = true
    static var isLoading: Bool = true
    
    static var previews: some View {
        LoadingButtonStyle(
            isSignIn: isSignIn,
            isLoading: isLoading
        ) {}
    }
}
