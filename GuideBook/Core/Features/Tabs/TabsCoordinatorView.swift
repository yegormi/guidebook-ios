//
//  TabsCoordinatorView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 27.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct TabsCoordinatorView: View {
    let store: StoreOf<TabsCoordinator>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            TabView(
                selection: viewStore.binding(
                    get: \.selectedTab,
                    send: { .tabSelected($0) }
                )
            ) {
                HomeCoordinatorView(
                    store: self.store.scope(
                        state: \.home,
                        action: { .home($0) }
                    )
                )
                .tabItem { Label("Home", systemImage: "house") }
                .tag(Tab.home)
                
                FavoritesCoordinatorView(
                    store: self.store.scope(
                        state: \.favorites,
                        action: { .favorites($0) }
                    )
                )
                .tabItem { Label("Favorites", systemImage: "heart") }
                .tag(Tab.favorites)
                
                SettingsView(
                    store: self.store.scope(
                        state: \.settings,
                        action: { .settings($0) }
                    )
                )
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .tag(Tab.settings)
            }
        }
    }
}



struct TabsCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        TabsCoordinatorView(
            store: Store(initialState: .initialState) {
                TabsCoordinator()
                    ._printChanges()
            }
        )
    }
}
