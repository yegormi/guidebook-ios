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
            VStack {
                Spacer()
                Image("BookIcon")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .scaledToFit()
                    .frame(width: 150)
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            viewStore.send(.appDidLaunch, animation: .default)
                        }
                    }
                Spacer()
                Text("GuideBook")
                    .font(.system(size: 30, weight: .regular))
                    .padding(.bottom, 40)
            }
        }

    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(
            store: Store(initialState: SplashFeature.State()) {
                SplashFeature()
                    ._printChanges()
            }
        )
    }
}
