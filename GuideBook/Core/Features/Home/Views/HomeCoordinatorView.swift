//
//  HomeCoordinatorView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct HomeCoordinatorView: View {
    let store: StoreOf<HomeCoordinator>
    
    var body: some View {
        TCARouter(store) { screen in
            SwitchStore(screen) { screen in
                switch screen {
                case .main:
                    CaseLet(
                        /HomeScreen.State.main,
                         action: HomeScreen.Action.main,
                         then: HomeMainView.init
                    )
                case .details:
                    CaseLet(
                        /HomeScreen.State.details,
                         action: HomeScreen.Action.details,
                         then: DetailsView.init
                    )
                }
            }
        }
    }
}
