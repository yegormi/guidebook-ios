//
//  HomeScreen.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeScreen: Reducer {
    enum State: Equatable {
        case main(HomeMain.State)
        case details(DetailsCoordinator.State)
    }
    
    enum Action: Equatable {
        case main(HomeMain.Action)
        case details(DetailsCoordinator.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: /State.main, action: /Action.main) {
            HomeMain()
        }
        Scope(state: /State.details, action: /Action.details) {
            DetailsCoordinator()
        }
    }
}
