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
    }
    
    enum Action: Equatable {
        case main(FavoritesMain.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: /State.main, action: /Action.main) {
            FavoritesMain()
        }
    }
}
