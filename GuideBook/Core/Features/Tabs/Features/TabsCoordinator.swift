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
    struct State: Equatable {
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
        case tabSelected(Tab)
        case home(HomeCoordinator.Action)
        case favorites(FavoritesCoordinator.Action)
        case settings(SettingsCoordinator.Action)
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
        Reduce<State, Action> { state, action in
            switch action {
            case .tabSelected(let tab):
                state.selectedTab = tab
            default:
                break
            }
            return .none
        }
    }
}
