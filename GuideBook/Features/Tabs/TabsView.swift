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
            TabView(
                selection: viewStore.binding(
                    get: \.selectedTab,
                    send: TabsFeature.Action.tabSelected
                )
            ) {
                NavigationView {
                    HomeView(
                        store: self.store.scope(
                            state: \.homeState,
                            action: TabsFeature.Action.home
                        )
                    )
                    .navigationTitle(viewStore.selectedTab.name)
                    .navigationBarTitleDisplayMode(.inline)
                }
                .tabItem { Label("Home", systemImage: "house") }
                .tag(TabsFeature.Tab.home)
                
                NavigationView {
                    FavoritesView(
                        store: self.store.scope(
                            state: \.favoritesState,
                            action: TabsFeature.Action.favorites
                        )
                    )
                    .navigationTitle(viewStore.selectedTab.name)
                    .navigationBarTitleDisplayMode(.inline)
                }
                .tabItem { Label("Favorites", systemImage: "heart") }
                .tag(TabsFeature.Tab.favorites)
                
                NavigationView {
                    SettingsView(
                        store: self.store.scope(
                            state: \.settingsState,
                            action: TabsFeature.Action.settings
                        )
                    )
                    .navigationTitle(viewStore.selectedTab.name)
                    .navigationBarTitleDisplayMode(.inline)
                }
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .tag(TabsFeature.Tab.settings)
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
