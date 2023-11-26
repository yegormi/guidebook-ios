//
//  Coordinator.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 24.11.2023.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

struct Coordinator: Reducer {
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
            case .routeAction(_, .splash(.timerFired)):
                state.routes.removeAll()

                if let _ = retrieveAuthResponse() {
                    state.routes.push(.tabs(.init()))
                } else {
                    state.routes.push(.auth(.init()))
                }

            case .routeAction(_, .tabs(.settings(.alert(.presented(.confirmSignOutTapped))))):
                state.routes.removeAll()
                state.routes.push(.auth(.init()))

            case .routeAction(_, .tabs(.settings(.alert(.presented(.confirmDeleteTapped))))):
                state.routes.removeAll()
                state.routes.push(.auth(.init()))

            case .routeAction(_, action: .auth(.authSuccessful)):
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

//    func getAuthResponse() -> AuthResponse? {
//        if let authResponseData = keychain.getData("AuthResponse"),
//           let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: authResponseData) {
//            return authResponse
//        }
//        return nil
//    }
    
    func retrieveAuthResponse() -> AuthResponse? {
        if let authResponseData = UserDefaults.standard.data(forKey: "AuthResponse"),
           let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: authResponseData) {
            return authResponse
        }
        return nil
    }
    
    func eraseAuthResponse() {
        UserDefaults.standard.removeObject(forKey: "AuthResponse")
    }
    
    func saveAuthResponse(response: AuthResponse) {
        if let authResponse = try? JSONEncoder().encode(response) {
            UserDefaults.standard.set(authResponse, forKey: "AuthResponse")
        }
    }
}
