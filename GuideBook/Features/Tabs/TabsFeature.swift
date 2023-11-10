//
//  TabsFeature.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 05.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct TabsFeature: Reducer {
    struct State: Equatable {
        var selectedTab = Tab.home
        var homeState = HomeFeature.State()
        var favoritesState = FavoritesFeature.State()
        var settingsState = SettingsFeature.State()
    }
    
    enum Tab {
        case home
        case favorites
        case settings
    }
    
    enum Action: Equatable {
        case tabSelected(Tab)
        case home(HomeFeature.Action)
        case favorites(FavoritesFeature.Action)
        case settings(SettingsFeature.Action)
        
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.homeState, action: /Action.home) {
            HomeFeature()
        }
        Scope(state: \.favoritesState, action: /Action.favorites) {
            FavoritesFeature()
        }
        Scope(state: \.settingsState, action: /Action.settings) {
            SettingsFeature()
        }
        Reduce { state, action in
            switch action {
            case let .tabSelected(tab):
                state.selectedTab = tab
                return .none
            case .home:
                return .none
            case .favorites:
                return .none
            case .settings:
                return .none
            }
        }
    }
}
