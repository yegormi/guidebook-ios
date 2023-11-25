//
//  ScreenView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 24.11.2023.
//
//

import SwiftUI
import ComposableArchitecture

struct ScreenView: View {
    let store: StoreOf<ScreenFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text("Hello World!!!")
        }
    }
}
