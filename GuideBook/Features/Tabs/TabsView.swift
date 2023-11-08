//
//  TabsView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 05.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct TabsView: View {
    let store: StoreOf<TabsFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                TabView(
                    selection: viewStore.binding(
                        get: \.selectedTab,
                        send: TabsFeature.Action.tabSelected
                    )
                ) {
                    HomeView(
                        store: Store(initialState: HomeFeature.State()) {
                            HomeFeature()
                                ._printChanges()
                        }
                    )
                    .tabItem { Label("Home", systemImage: "house") }
                    .tag(TabsFeature.Tab.home)
                    
                    
                    FavoritesView(
                        store: Store(initialState: FavoritesFeature.State()) {
                            FavoritesFeature()
                                ._printChanges()
                        }
                    )
                    .tabItem { Label("Favorites", systemImage: "heart") }
                    .tag(TabsFeature.Tab.favorites)
                    
                    SettingsView(
                        store: Store(initialState: SettingsFeature.State()) {
                            SettingsFeature()
                                ._printChanges()
                        }
                    )
                    .tabItem { Label("Settings", systemImage: "gearshape") }
                    .tag(TabsFeature.Tab.settings)
                }
            }
        }
    }
}



struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView(
            store: Store(initialState: TabsFeature.State()) {
                TabsFeature()
                    ._printChanges()
            }
        )
    }
}
