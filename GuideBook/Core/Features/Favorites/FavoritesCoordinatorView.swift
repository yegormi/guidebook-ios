//
//  FavoritesView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//
//

import SwiftUI
import ComposableArchitecture

struct FavoritesCoordinatorView: View {
    let store: StoreOf<FavoritesCoordinator>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text("Favorites page")
        }
        .navigationTitle(Tab.favorites.rawValue)
    }
}
