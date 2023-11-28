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
    }
    
    enum Action: Equatable {
        case main(HomeMain.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: /State.main, action: /Action.main) {
            HomeMain()
        }
    }
}
