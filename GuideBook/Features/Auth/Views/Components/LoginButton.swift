//
//  LoginButton.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 06.11.2023.
//

import SwiftUI

struct LoginButton: View {
    let authType: AuthType
    @State var isLoading: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                Text(isLoading ? "" : authType.text.uppercased())
                    .font(.system(size: 14, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, minHeight: 45)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1, anchor: .center)
                }
                
            }
            .disabled(isLoading)
        }
    }
}


struct LoginButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LoginButton(authType: .signIn, isLoading: true) {
                // Add your action here
            }
            .padding(20)

            LoginButton(authType: .signUp, isLoading: false) {
                // Add your action here
            }
            .padding(20)
        }
    }
}
