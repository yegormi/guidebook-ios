//
//  AuthFeature.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 05.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct AuthFeature: Reducer {
    let networkManager = NetworkManager.shared
    
    struct State: Equatable {
        var username: String = ""
        var email: String = ""
        var password: String = ""
        var confirmPassword: String = ""
        
        var authType: AuthType = .signIn
        var isLoading: Bool = false
        var response: AuthResponse?
    }
    
    enum Action: Equatable {
        case usernameChanged(String)
        case emailChanged(String)
        case passwordChanged(String)
        case confirmPasswordChanged(String)
        
        case toggleButtonTapped
        case authButtonTapped
        
        case authSuccessful(AuthResponse)
//        case authError(ErrorResponse)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .usernameChanged(let current):
            state.username = current
            return .none
        case .emailChanged(let current):
            state.email = current
            return .none
        case .passwordChanged(let current):
            state.password = current
            return .none
        case .confirmPasswordChanged(let current):
            state.confirmPassword = current
            return .none
        case .toggleButtonTapped:
            state.authType = state.authType == .signIn ? .signUp : .signIn
            return .none
        case .authButtonTapped:
            let email = state.email
            let password = state.password
            
            state.isLoading = true
            
            switch state.authType {
            case .signIn:
                return .run { send in
                    do {
                        let result = try await performSignIn(
                            email: email,
                            password: password
                        )
                        await send(.authSuccessful(result))
                    } catch {
                        print(error)
                    }
                }
            case .signUp:
                let username = state.username
                
                return .run { send in
                    do {
                        let result = try await performSignUp(
                            username: username, 
                            email: email,
                            password: password
                        )
                        await send(.authSuccessful(result))
                    } catch {
                        print(error)
                    }
                }
            }
        case .authSuccessful(let response):
            state.response = response
            state.isLoading = false
            return .none
//        case .authError(let error):
//            state.isLoading = false
//            return .none
        }
    }
    
    func performSignIn(email: String, password: String) async throws -> AuthResponse {
        let signInRequest = SignInRequest(email: email, password: password)
        return try await networkManager.performRequest(
            baseURL: "https://guidebook-api.azurewebsites.net",
            endpoint: "/auth/signin",
            method: .post,
            decodedBody: signInRequest
        )
    }

    func performSignUp(username: String, email: String, password: String) async throws -> AuthResponse {
        let signUpRequest = SignUpRequest(username: username, email: email, password: password)
        return try await networkManager.performRequest(
            baseURL: "https://guidebook-api.azurewebsites.net",
            endpoint: "/auth/signup",
            method: .post,
            decodedBody: signUpRequest
        )
    }
}

