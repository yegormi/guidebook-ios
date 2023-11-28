//
//  SettingsScreen.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 27.11.2023.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

@Reducer
struct SettingsScreen: Reducer {
    enum State: Equatable {
        case main(SettingsFeature.State)
    }
    
    enum Action: Equatable {
        case main(SettingsFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: /State.main, action: /Action.main) {
            SettingsFeature()
        }
    }
}
