//
//  SettingsCoordinatorView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 27.11.2023.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct SettingsCoordinatorView: View {
    let store: StoreOf<SettingsCoordinator>
    
    var body: some View {
        TCARouter(store) { screen in
            SwitchStore(screen) { screen in
                switch screen {
                case .main:
                    CaseLet(
                        /SettingsScreen.State.main,
                         action: SettingsScreen.Action.main,
                         then: SettingsView.init
                    )
                }
            }
        }
    }
}
