//
//  RootView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store: StoreOf<RootFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Group {
                if viewStore.isLaunched {
                    if viewStore.authState.response != nil {
                        TabsView(
                            store: self.store.scope(
                                state: \.tabsState,
                                action: RootFeature.Action.tabs
                            )
                        )
                    } else {
                        AuthView(
                            store: self.store.scope(
                                state: \.authState,
                                action: RootFeature.Action.auth
                            )
                        )
                    }
                } else {
                    SplashView()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    viewStore.send(.appLaunched, animation: .default)
                }
//                viewStore.send(.retrieveToken)
            }
        }
    }
}
