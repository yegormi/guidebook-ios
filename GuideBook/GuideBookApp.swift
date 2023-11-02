//
//  GuideBookApp.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 24.10.2023.
//

import SwiftUI

@main
struct GuideBookApp: App {
    var body: some Scene {
        WindowGroup {
            ParentView()
                .environmentObject(AuthViewModel())
                .environmentObject(FavoritesViewModel())
                .environmentObject(GuideViewModel())
                .environmentObject(SettingsViewModel())
        }
    }
}
