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
            TabsView(
                store: Store(initialState: TabsFeature.State()) {
                    TabsFeature()
                        ._printChanges()
                }
            )
        }
    }
}
