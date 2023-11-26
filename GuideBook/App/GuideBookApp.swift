//
//  GuideBookApp.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 24.10.2023.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

@main
struct GuideBookApp: App {         
    var body: some Scene {
        WindowGroup {
            CoordinatorView(
                store: Store(initialState: .initialState) {
                    Coordinator()
                        ._printChanges()
                }
            )
        }
    }
}
