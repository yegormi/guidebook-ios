//
//  DetailsCoordinatorView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 02.12.2023.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct DetailsCoordinatorView: View {
    let store: StoreOf<DetailsCoordinator>
    
    var body: some View {
        TCARouter(store) { screen in
            SwitchStore(screen) { screen in
                switch screen {
                case .main:
                    CaseLet(
                        /DetailsScreen.State.main,
                         action: DetailsScreen.Action.main,
                         then: DetailsMainView.init
                    )
                case .steps:
                    CaseLet(
                        /DetailsScreen.State.steps,
                         action: DetailsScreen.Action.steps,
                         then: DetailsStepsView.init
                    )
                }
            }
        }
    }
}
