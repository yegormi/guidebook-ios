//
//  RootScreen.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//
//

import Foundation
import ComposableArchitecture

struct RootScreen: Reducer {
    enum State: Equatable {
        case splash(SplashFeature.State)
        case auth(AuthFeature.State)
        case tabs(TabsCoordinator.State)
    }
    
    enum Action: Equatable {
        case splash(SplashFeature.Action)
        case auth(AuthFeature.Action)
        case tabs(TabsCoordinator.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: /State.splash, action: /Action.splash) {
            SplashFeature()
        }
        Scope(state: /State.auth, action: /Action.auth) {
            AuthFeature()
        }
        Scope(state: /State.tabs, action: /Action.tabs) {
            TabsCoordinator()
        }
    }
}
