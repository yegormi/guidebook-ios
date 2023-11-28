//
//  SettingsCoordinator.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 27.11.2023.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

@Reducer
struct SettingsCoordinator: Reducer {
    struct State: Equatable, IndexedRouterState {
        var routes: [Route<SettingsScreen.State>]
        static let initialState = State(
            routes: [.root(.main(.init()), embedInNavigationView: true)]
        )
    }
    
    enum Action: Equatable, IndexedRouterAction {
        case routeAction(Int, action: SettingsScreen.Action)
        case updateRoutes([Route<SettingsScreen.State>])
    }
    
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            default:
                break
            }
            return .none
        }.forEachRoute {
            SettingsScreen()
        }
    }
}

