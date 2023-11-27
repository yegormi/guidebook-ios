//
//  HomeCoordinator.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 27.11.2023.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

struct HomeCoordinator: Reducer {
    struct State: Equatable, IndexedRouterState {
        var routes: [Route<HomeScreen.State>]
        static let initialState = State(
            routes: [.root(.main(.init(guides: [])), embedInNavigationView: true)]
        )
    }
    
    enum Action: Equatable, IndexedRouterAction {
        case routeAction(Int, action: HomeScreen.Action)
        case updateRoutes([Route<HomeScreen.State>])
    }
    
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            default:
                break
            }
            return .none
        }.forEachRoute {
            HomeScreen()
        }
    }
}
