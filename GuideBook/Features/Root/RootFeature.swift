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
    enum State: Equatable {
        case splash(SplashFeature.State)
        case tabs(TabsFeature.State)
        case auth(AuthFeature.State)
    }
    
    enum Action: Equatable {
        case splash(SplashFeature.Action)
        case tabs(TabsFeature.Action)
        case auth(AuthFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: /State.auth, action: /Action.auth) {
            AuthFeature()
        }
        Scope(state: /State.tabs, action: /Action.tabs) {
            TabsFeature()
        }
        Scope(state: /State.splash, action: /Action.splash) {
            SplashFeature()
        }

    }
}
