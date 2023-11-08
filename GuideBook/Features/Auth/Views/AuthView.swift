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
            ScrollView {
                VStack {
                    Header("📘 GuideBook")
                    
                    if viewStore.authType == .signUp {
                        AuthTitle(authType: .signUp)
                            .padding(.vertical, 30)
                    } else {
                        AuthTitle(authType: .signIn)
                            .padding(.vertical, 30)
                    }
                    
                    if viewStore.authType == .signUp {
                        InputField(
                            label: "Username",
                            text: viewStore.binding(
                                get: \.username,
                                send: { .usernameChanged($0) }
                            ),
                            type: .username,
                            isInvalid: viewStore.usernameError != nil
                        )
                        
                        if let usernameError = viewStore.usernameError {
                            ErrorText(message: usernameError)
                        }
                    }
                    
                    InputField(
                        label: "Email",
                        text: viewStore.binding(
                            get: \.email,
                            send: { .emailChanged($0) }
                        ),
                        type: .email,
                        isInvalid: viewStore.emailError != nil
                    )
                                        
                    if let emailError = viewStore.emailError {
                        ErrorText(message: emailError)
                    }
                    
                    InputField(
                        label: "Password",
                        text: viewStore.binding(
                            get: \.password,
                            send: { .passwordChanged($0) }
                        ).removeDuplicates(),
                        type: .password,
                        isInvalid: viewStore.passwordError != nil
                    )
                    .padding(.top, 10)
                    
                    if let passwordError = viewStore.passwordError {
                        ErrorText(message: passwordError)
                    }
                    
                    if viewStore.authType == .signUp {
                        InputField(
                            label: "Confirm Password",
                            text: viewStore.binding(
                                get: \.confirmPassword,
                                send: { .confirmPasswordChanged($0) }
                            ).removeDuplicates(),
                            type: .password,
                            isInvalid: (
                                viewStore.password != viewStore.confirmPassword &&
                                !viewStore.confirmPassword.isEmpty
                            )
                        )
                        .padding(.top, 10)
                    }
                    
                    AuthButton(authType: viewStore.authType, isLoading: viewStore.isLoading, action: {
                        viewStore.send(.authButtonTapped)
                    })
                    .disabled(!viewStore.isLoginAllowed)
                    .opacity(viewStore.isLoginAllowed ? 1 : 0.5)
                    .padding(.top, 20)
                    
                    AuthToggleButton(authType: viewStore.authType, onTap: {
                        viewStore.send(.toggleButtonTapped, animation: .default)
                    })
                    .padding(.vertical, 20)
                }
                .padding(30)
            }
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
