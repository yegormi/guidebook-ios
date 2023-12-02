//
//  HomeCoordinator.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 27.11.2023.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

@Reducer
struct HomeCoordinator: Reducer {
    struct State: Equatable, IndexedRouterState {
        var routes: [Route<HomeScreen.State>]
        static let initialState = State(
            routes: [.root(.main(.init(guides: [], details: nil)), embedInNavigationView: true)]
        )
    }
    
    enum Action: Equatable, IndexedRouterAction {
        case routeAction(Int, action: HomeScreen.Action)
        case updateRoutes([Route<HomeScreen.State>])
    }
    
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .routeAction(_, action: .main(.onItemTapped(let guide))):
                state.routes.push(.details(.init(
                    routes: [.root(.main(.init(guide: guide)))]
                )))
            default:
                break
            }
            return .none
        }.forEachRoute {
            HomeScreen()
        }
    }
}
