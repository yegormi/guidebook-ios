//
//  DetailsScreen.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 02.12.2023.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DetailsScreen: Reducer {
    enum State: Equatable {
        case main(DetailsMain.State)
        case steps(DetailsSteps.State)
    }
    
    enum Action: Equatable {
        case main(DetailsMain.Action)
        case steps(DetailsSteps.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: /State.main, action: /Action.main) {
            DetailsMain()
        }
        Scope(state: /State.steps, action: /Action.steps) {
            DetailsSteps()
        }
    }
}
