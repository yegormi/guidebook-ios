//
//  RootView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct CoordinatorView: View {
    let store: StoreOf<Coordinator>
    
    var body: some View {
        TCARouter(store) { screen in
            SwitchStore(screen) { screen in
                switch screen {
                case .splash:
                    CaseLet(
                        /RootFeature.State.splash,
                         action: RootFeature.Action.splash,
                         then: SplashView.init
                    )
                    
                case .tabs:
                    CaseLet(
                        /RootFeature.State.tabs,
                         action: RootFeature.Action.tabs,
                         then: TabsView.init
                    )
                    
                case .auth:
                    CaseLet(
                        /RootFeature.State.auth,
                         action: RootFeature.Action.auth,
                         then: AuthView.init
                    )
                }
            }
        }
    }
}
