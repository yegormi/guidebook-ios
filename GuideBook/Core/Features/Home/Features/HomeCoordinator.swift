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
        var routes: [Route<HomeFeature.State>]
        static let initialState = State(routes: [.root(.main(.init()), embedInNavigationView: true)])
    }
    
    enum Action: Equatable, IndexedRouterAction {
        case routeAction(Int, action: HomeFeature.Action)
        case updateRoutes([Route<HomeFeature.State>])
    }
    
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            default:
                break
            }
            return .none
        }.forEachRoute {
            HomeFeature()
        }
    }
}
