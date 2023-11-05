//
//  AuthFeature.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 05.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct AuthFeature: Reducer {
    struct State: Equatable {
        var username: String = ""
        var email: String = ""
        var password: String = ""
        var confirmPassword: String = ""
        var authType: AuthType = .signIn
    }
    
    enum Action: Equatable {
        case usernameChanged(String)
        case emailChanged(String)
        case passwordChanged(String)
        case confirmPasswordChanged(String)
        case toggleButtonTapped
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
        }
    }
}

