//
//  TabsView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 27.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct TabsView: View {
    let store: StoreOf<TabsFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            TabView(
                selection: viewStore.binding(
                    get: \.selectedTab,
                    send: TabsFeature.Action.tabSelected
                )
            ) {
                HomeCoordinatorView(
                    store: self.store.scope(
                        state: \.home,
                        action: \.home
                    )
                )
                .tabItem { Label("Home", systemImage: "house") }
                .tag(Tab.home)
                
                FavoritesCoordinatorView(
                    store: self.store.scope(
                        state: \.favorites,
                        action: \.favorites
                    )
                )
                .tabItem { Label("Favorites", systemImage: "heart") }
                .tag(Tab.favorites)
                
                SettingsCoordinatorView(
                    store: self.store.scope(
                        state: \.settings,
                        action: \.settings
                    )
                )
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .tag(Tab.settings)
            }
            .alert(
                store: self.store.scope(
                    state: \.$alert,
                    action: \.alert
                )
            )
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}



struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView(
            store: Store(initialState: .initialState) {
                TabsFeature()
                    ._printChanges()
            }
        )
    }
}
