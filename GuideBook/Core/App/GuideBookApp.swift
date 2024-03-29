//
//  GuideBookApp.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 24.10.2023.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

@main
struct GuideBookApp: App {
    var body: some Scene {
        WindowGroup {
            RootCoordinatorView(
                store: Store(initialState: .initialState) {
                    RootCoordinator()
                        ._printChanges()
                }
            )
        }
    }
}
