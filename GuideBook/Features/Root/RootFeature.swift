//
//  RootFeature.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 05.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct RootFeature: Reducer {
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
        case tabSelected(tab)
        case home(HomeFeature.State())
        case favorites(FavoritesFeature.State())
        case settings(SettingsFeature.State())

    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
            
        }
    }
    
}
