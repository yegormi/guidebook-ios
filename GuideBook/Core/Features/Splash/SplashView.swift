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
                .transition(.move(edge: .bottom)
                    .combined(with: .scale(scale: 0.3))
                    .combined(with: .opacity)
                    .animation(.spring)
                )
        }
        
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(
            store: Store(initialState: .initialState) {
                SplashFeature()
            }
        )
    }
}
