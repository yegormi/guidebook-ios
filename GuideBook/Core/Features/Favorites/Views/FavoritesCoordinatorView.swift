//
//  FavoritesView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct FavoritesCoordinatorView: View {
    let store: StoreOf<FavoritesCoordinator>
    
    var body: some View {
        TCARouter(store) { screen in
            SwitchStore(screen) { screen in
                switch screen {
                case .main:
                    CaseLet(
                        /FavoritesScreen.State.main,
                         action: FavoritesScreen.Action.main,
                         then: FavoritesMainView.init
                    )
                }
            }
        }
    }
}
