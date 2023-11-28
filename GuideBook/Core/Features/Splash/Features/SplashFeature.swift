//
//  SplashFeature.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 24.11.2023.
//
//

import Foundation
import ComposableArchitecture

@Reducer
struct SplashFeature: Reducer {
    struct State: Equatable {
        var response: AuthResponse?
        static let initialState = Self()
    }
    
    enum Action: Equatable {
        case appDidLaunch
        case auth
        case tabs
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .appDidLaunch:
                state.response = AuthService.shared.retrieveToken()
                if state.response != nil {
                    return .send(.tabs)
                } else {
                    return .send(.auth)
                }
            case .auth:
                return .none
            case .tabs:
                return .none
            }
        }
    }
}
