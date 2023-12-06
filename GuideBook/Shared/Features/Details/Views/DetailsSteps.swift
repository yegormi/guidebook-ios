//
//  DetailsSteps.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 02.12.2023.
//

import SwiftUI
import ComposableArchitecture
import SkeletonUI

struct DetailsStepsView: View {
    let store: StoreOf<DetailsSteps>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            StepsPager(steps: viewStore.steps, guide: viewStore.guide)
        }
    }
    
}


@Reducer
struct DetailsSteps: Reducer {
    struct State: Equatable {
        var guide: Guide
        var steps: [GuideStep]
    }
    
    enum Action: Equatable {
    }
    
    var body: some Reducer<State, Action> {
        EmptyReducer()
    }
    
}
