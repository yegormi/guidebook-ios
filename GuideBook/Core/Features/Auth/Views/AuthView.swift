//
//  AuthView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 05.11.2023.
//

import SwiftUI
import ComposableArchitecture
import AlertToast
import Reachability

struct AuthView: View {
    let store: StoreOf<AuthFeature>
    let reachability = Reachability.shared
        
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView {
                VStack {
                    HeaderView("📘 GuideBook")
                    
                    HStack {
                        switch viewStore.authType {
                        case .signIn:
                            AuthTitle(authType: .signIn)
                                .padding(.vertical, 30)
                        case .signUp:
                            AuthTitle(authType: .signUp)
                                .padding(.vertical, 30)
                        }
                        Spacer()
                    }
                    
                    VStack(spacing: 15) {
                        if viewStore.authType == .signUp {
                            InputField(
                                label: "Username",
                                text: viewStore.binding(
                                    get: \.username,
                                    send: AuthFeature.Action.usernameChanged
                                ),
                                type: .username,
                                isInvalid: viewStore.usernameError != nil,
                                errorText: viewStore.usernameError
                            )
                        }
                        
                        InputField(
                            label: "Email",
                            text: viewStore.binding(
                                get: \.email,
                                send: AuthFeature.Action.emailChanged
                            ),
                            type: .email,
                            isInvalid: viewStore.emailError != nil,
                            errorText: viewStore.emailError
                        )
                        
                        InputField(
                            label: "Password",
                            text: viewStore.binding(
                                get: \.password,
                                send: AuthFeature.Action.passwordChanged
                            ).removeDuplicates(),
                            type: .password,
                            isInvalid: viewStore.passwordError != nil,
                            errorText: viewStore.passwordError
                        )
                        
                        if viewStore.authType == .signUp {
                            InputField(
                                label: "Confirm Password",
                                text: viewStore.binding(
                                    get: \.confirmPassword,
                                    send: AuthFeature.Action.confirmPasswordChanged
                                ).removeDuplicates(),
                                type: .password,
                                isInvalid: (
                                    viewStore.password != viewStore.confirmPassword &&
                                    !viewStore.confirmPassword.isEmpty
                                )
                            )
                            .transition(.opacity)
                        }
                    }
                    
                    AuthButton(authType: viewStore.authType, isLoading: viewStore.isLoading, action: {
                        if reachability.currentPath.isReachable {
                            viewStore.send(.authButtonTapped)
                        } else {
                            viewStore.send(.toastPresented)
                        }
                    })
                    .scaleButton()
                    .disabled(!viewStore.isLoginAllowed)
                    .opacity(!viewStore.isLoginAllowed ? 0.5 : 1)
                    .padding(.top, 20)
                    
                    AuthToggleButton(authType: viewStore.authType, onTap: {
                        viewStore.send(.toggleButtonTapped, animation: .easeInOut)
                    })
                    .padding(.vertical, 20)
                    
                    Spacer()
                }
                .padding(30)
            }
            .toast(isPresenting: viewStore.binding(
                get: \.isToastPresented,
                send: AuthFeature.Action.toastPresented
            )) {
                AlertToast(displayMode: .hud, type: .error(Color.red), title: "No internet connection")
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
