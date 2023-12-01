//
//  TabsCoordinator.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 27.11.2023.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

enum Tab: String, CaseIterable, Equatable {
    case home = "Home"
    case favorites = "Favorites"
    case settings = "Settings"
}

@Reducer
struct TabsCoordinator: Reducer {
    @Dependency(\.authClient) var authClient
    @Dependency(\.keychainClient) var keychainClient
    
    struct State: Equatable {
        @PresentationState var alert: AlertState<Action.Alert>?
        var token: String = ""
        var user: UserInfo?
        var error: FailResponse?
        
        var home: HomeCoordinator.State
        var favorites: FavoritesCoordinator.State
        var settings: SettingsCoordinator.State
        var selectedTab: Tab
        
        static let initialState = State(
            home: .initialState,
            favorites: .initialState,
            settings: .initialState,
            selectedTab: .home
        )
    }
    
    enum Action: Equatable {
        case alert(PresentationAction<Alert>)
        
        case expiredAlertPresented
        
        case tabSelected(Tab)
        case home(HomeCoordinator.Action)
        case favorites(FavoritesCoordinator.Action)
        case settings(SettingsCoordinator.Action)
        
        case onAppear
        case getSelf
        case onGetSelfSuccess(UserInfo)
        case onGetSelfError(FailResponse)
        
        enum Alert: Equatable {
            case confirmTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.home, action: /Action.home) {
            HomeCoordinator()
        }
        Scope(state: \.favorites, action: /Action.favorites) {
            FavoritesCoordinator()
        }
        Scope(state: \.settings, action: /Action.settings) {
            SettingsCoordinator()
        }
        Reduce { state, action in
            switch action {
            case .expiredAlertPresented:
                state.alert = AlertState {
                    TextState("Session Expired")
                } actions: {
                    ButtonState(role: .cancel, action: .confirmTapped) {
                        TextState("Ok")
                    }
                } message: {
                    TextState("Please sign in again.")
                }
                return .none
                
            case .alert(.presented(.confirmTapped)):
                deleteToken()
                return .none
            case .alert:
                return .none
                
            case .onAppear:
                state.token = retrieveToken()
                return .run { [token = state.token] send in
                    do {
                        let user = try await getSelf(with: token)
                        await send(.onGetSelfSuccess(user))
                    } catch let ErrorResponse.failedWithResponse(user){
                        await send(.onGetSelfError(user))
                    } catch {
                        print(error)
                    }
                }
            case .onGetSelfSuccess(let user):
                state.user = user
                return .none
            case .onGetSelfError(let error):
                state.error = error
                
                switch error.code {
                case RequestError.tokenExpired.code:
                    return .send(.expiredAlertPresented)
                default:
                    return .none
                }
            case .tabSelected(let tab):
                state.selectedTab = tab
            default:
                break
            }
            return .none
        }
        .ifLet(\.$alert, action: \.alert)
    }
    
    private func deleteToken() {
        keychainClient.deleteToken()
    }
    
    private func retrieveToken() -> String {
        keychainClient.retrieveToken()?.accessToken ?? ""
    }
    
    private func getSelf(with token: String) async throws -> UserInfo {
        return try await authClient.performGetSelf(token)
    }
}
