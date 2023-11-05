//
//  AuthView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 05.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct AuthView: View {
    let store: StoreOf<AuthFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Header()
                
                if viewStore.authType == .signUp {
                    InputField(
                        label: "Username",
                        text: viewStore.binding(
                            get: { $0.username },
                            send: { .usernameChanged($0) }
                        ),
                        type: .username,
                        isInvalid: false
                    )
                    .padding(.bottom, 10)
                }
                
                InputField(
                    label: "Email",
                    text: viewStore.binding(
                        get: { $0.email },
                        send: { .emailChanged($0) }
                    ),
                    type: .email,
                    isInvalid: false
                )
                .padding(.bottom, 10)
                
                InputField(
                    label: "Password",
                    text: viewStore.binding(
                        get: { $0.password },
                        send: { .passwordChanged($0) }
                    ),
                    type: .password,
                    isInvalid: false
                )
                .padding(.bottom, 10)
                
                if viewStore.authType == .signUp {
                    InputField(
                        label: "Confirm Password",
                        text: viewStore.binding(
                            get: { $0.confirmPassword },
                            send: { .confirmPasswordChanged($0) }
                        ),
                        type: .password,
                        isInvalid: false
                    )
                    .padding(.bottom, 10)
                }
                
                AuthToggleButton(authType: viewStore.authType, onTap: {
                    viewStore.send(
                        .toggleButtonTapped,
                        animation: .snappy())
                })
            }
            .padding(30)
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(
            store: Store(initialState: AuthFeature.State()) {
                AuthFeature()
                    ._printChanges()
            }
        )
    }
}
