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
                    send: TabsCoordinator.Action.tabSelected
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
