//
//  HomeCoordinatorView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//
//

import SwiftUI
import ComposableArchitecture

struct HomeCoordinatorView: View {
    let store: StoreOf<HomeCoordinator>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text("Home page")
        }
        .navigationTitle(Tab.home.rawValue)
    }
}
