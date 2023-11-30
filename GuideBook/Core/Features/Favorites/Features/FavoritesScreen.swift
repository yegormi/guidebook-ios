//
//  FavoritesScreen.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//
//

import Foundation
import ComposableArchitecture

@Reducer
struct FavoritesScreen: Reducer {
    enum State: Equatable {
        case main(FavoritesMain.State)
        case details(DetailsFeature.State)
    }
    
    enum Action: Equatable {
        case main(FavoritesMain.Action)
        case details(DetailsFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: /State.main, action: /Action.main) {
            FavoritesMain()
        }
        Scope(state: /State.details, action: /Action.details) {
            DetailsFeature()
        }
    }
}
