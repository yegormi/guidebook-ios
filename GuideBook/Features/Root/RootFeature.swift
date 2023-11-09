//
//  RootFeature.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//
//

import Foundation
import ComposableArchitecture

struct RootFeature: Reducer {
    struct State: Equatable {
        var isLaunched = false
        var authState = AuthFeature.State()
        var tabsState = TabsFeature.State()
        
    }
    
    enum Action: Equatable {
        case appLaunched
        case retrieveToken
        
        case auth(AuthFeature.Action)
        case tabs(TabsFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.authState, action: /Action.auth) {
            AuthFeature()
        }
        Scope(state: \.tabsState, action: /Action.tabs) {
            TabsFeature()
        }
        Reduce { state, action in
            switch action {
            case .appLaunched:
                state.isLaunched = true
                return .none
            case .retrieveToken:
                state.authState.response = retrieveAuthResponse()
                return .none
            case .auth:
                return .none
            case .tabs:
                return .none
            }
        }
    }
    
    func retrieveAuthResponse() -> AuthResponse? {
        if let authResponseData = UserDefaults.standard.data(forKey: "AuthResponse"),
           let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: authResponseData) {
            return authResponse
        }
        return nil
    }
}
