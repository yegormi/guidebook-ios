//
//  DetailsCoordinator.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 02.12.2023.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

@Reducer
struct DetailsCoordinator: Reducer {
    struct State: Equatable, IndexedRouterState {
        var routes: [Route<DetailsScreen.State>]
    }
    
    enum Action: Equatable, IndexedRouterAction {
        case routeAction(Int, action: DetailsScreen.Action)
        case updateRoutes([Route<DetailsScreen.State>])
    }
    
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .routeAction(_, action: .main(.onStepsButtonTapped(let guide, let steps))):
                state.routes.push(.steps(.init(guide: guide, steps: steps)))
            default:
                break
            }
            return .none
        }.forEachRoute {
            DetailsScreen()
        }
    }
}
