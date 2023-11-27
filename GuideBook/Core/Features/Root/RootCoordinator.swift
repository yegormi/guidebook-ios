//
//  RootCoordinator.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 24.11.2023.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

struct RootCoordinator: Reducer {
    struct State: Equatable, IndexedRouterState {
        var routes: [Route<RootScreen.State>]
        static let initialState = State(
            routes: [.root(.splash(.init()))]
        )
    }
    
    enum Action: IndexedRouterAction {
        case routeAction(Int, action: RootScreen.Action)
        case updateRoutes([Route<RootScreen.State>])
    }
    
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .routeAction(_, action: .splash(.auth)):
                state.routes.removeAll()
                state.routes.push(.auth(.init()))
                
            case .routeAction(_, action: .auth(.authSuccessful)):
                state.routes.removeAll()
                state.routes.push(.tabs(.initialState))
                
            case .routeAction(_, action: .splash(.tabs)):
                state.routes.removeAll()
                state.routes.push(.tabs(.initialState))
                
            case .routeAction(_, .tabs(.settings(.routeAction(_, action: .main(.onSignOut))))):
                state.routes.removeAll()
                state.routes.push(.auth(.init()))
                
            case .routeAction(_, .tabs(.settings(.routeAction(_, action: .main(.onDeleteSuccess))))):
                state.routes.removeAll()
                state.routes.push(.auth(.init()))
                
            default:
                break
            }
            return .none
        }.forEachRoute {
            RootScreen()
        }
    }
}
