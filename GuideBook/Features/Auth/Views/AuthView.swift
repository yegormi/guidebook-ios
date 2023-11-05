//
//  AuthView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 05.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct AuthView: View {
    let store: Store<AuthFeature.State, AuthFeature.Action>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                InputField(
                    placeholder: "Username",
                    text: viewStore.binding(
                        get: { $0.username },
                        send: { .usernameTextChanged($0) }
                    ),
                    type: .username,
                    isInvalid: false
                )
                InputField(
                    placeholder: "Email",
                    text: viewStore.binding(
                        get: { $0.email },
                        send: { .emailTextChanged($0) }
                    ),
                    type: .email,
                    isInvalid: false
                )
                InputField(
                    placeholder: "Password",
                    text: viewStore.binding(
                        get: { $0.password },
                        send: { .passwordTextChanged($0) }
                    ),
                    type: .password,
                    isInvalid: false
                )
                InputField(
                    placeholder: "Confirm Password",
                    text: viewStore.binding(
                        get: { $0.confirmPassword },
                        send: { .confirmPasswordTextChanged($0) }
                    ),
                    type: .confirmPassword,
                    isInvalid: viewStore.isInvalidPassword
                )
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
