//
//  FavoritesCoordinator.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 27.11.2023.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

@Reducer
struct FavoritesCoordinator: Reducer {
    struct State: Equatable, IndexedRouterState {
        var routes: [Route<FavoritesScreen.State>]
        static let initialState = State(
            routes: [.root(.main(.init()), embedInNavigationView: true)]
        )
    }
    
    enum Action: Equatable, IndexedRouterAction {
        case routeAction(Int, action: FavoritesScreen.Action)
        case updateRoutes([Route<FavoritesScreen.State>])
    }
    
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            default:
                break
            }
            return .none
        }.forEachRoute {
            FavoritesScreen()
        }
    }
}
