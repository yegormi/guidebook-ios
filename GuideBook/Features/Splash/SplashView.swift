//
//  SplashView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 24.11.2023.
//
//

import SwiftUI
import ComposableArchitecture

struct SplashView: View {
    let store: StoreOf<SplashFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text("📘 GuideBook")
                .font(.system(size: 40))
                .bold()
                .transition(.offset(y: -(Helpers.screen.height*0.9))
                    .combined(with: .scale(scale: 0.5))
                    .combined(with: .opacity)
                )
        }
    }
}
