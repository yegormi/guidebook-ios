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
        var routes: [Route<RootFeature.State>]
        static let initialState = State(routes: [.root(.splash(.init()))])
    }
    
    enum Action: IndexedRouterAction {
        case routeAction(Int, action: RootFeature.Action)
        case updateRoutes([Route<RootFeature.State>])
    }
    
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .routeAction(_, action: .splash(.auth)):
                state.routes.removeAll()
                state.routes.push(.auth(.init()))
                
            case .routeAction(_, action: .splash(.tabs)):
                state.routes.removeAll()
                state.routes.push(.tabs(.init()))
                
            case .routeAction(_, .tabs(.settings(.onSignOut))):
                state.routes.removeAll()
                state.routes.push(.auth(.init()))
                
            case .routeAction(_, .tabs(.settings(.onDeleteSuccess))):
                state.routes.removeAll()
                state.routes.push(.auth(.init()))
                
            case .routeAction(_, action: .auth(.saveToken)):
                state.routes.removeAll()
                state.routes.push(.tabs(.init()))
                
            default:
                break
            }
            return .none
        }.forEachRoute {
            RootFeature()
        }
    }
}
