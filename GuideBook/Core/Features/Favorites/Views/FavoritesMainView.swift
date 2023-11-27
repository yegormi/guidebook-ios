//
//  FavoritesMainView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 28.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct FavoritesMainView: View {
    let store: StoreOf<FavoritesMain>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text("Favorites -> Main")
        }
        .navigationTitle(Tab.favorites.rawValue)
    }
}
