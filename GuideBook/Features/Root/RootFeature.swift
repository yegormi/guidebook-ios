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
        
    }
    
    enum Action: Equatable {
        case appLaunched
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .appLaunched:
            state.isLaunched = true
            return .none
        }
    }
}
