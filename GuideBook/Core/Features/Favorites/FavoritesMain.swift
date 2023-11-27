//
//  FavoritesMain.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 27.11.2023.
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

struct FavoritesMain: Reducer {
    struct State: Equatable {

    }
    
    enum Action: Equatable {
        
    }
    
    var body: some Reducer<State, Action> {
        EmptyReducer()
    }
}
