//
//  GuideBookApp.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 24.10.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct GuideBookApp: App {
    var body: some Scene {
        WindowGroup {
            AuthView(
                store: Store(initialState: AuthFeature.State()) {
                    AuthFeature()
                        ._printChanges()
                }
            )
            
            
//            RootView(
//                store: Store(initialState: RootFeature.State()) {
//                    RootFeature()
//                        ._printChanges()
//                }
//            )
        }
    }
}