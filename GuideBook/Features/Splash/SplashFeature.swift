//
//  SplashFeature.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 24.11.2023.
//
//

import Foundation
import ComposableArchitecture

struct SplashFeature: Reducer {
    struct State: Equatable {
    }
    
    enum Action: Equatable {
        case timerFired
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .timerFired:
                return .none
            }
        }
    }
}
