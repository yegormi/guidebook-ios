//
//  SettingsViewModel.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 31.10.2023.
//

import Foundation

final class SettingsViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = true
    @Published var isSignOutAlertPresented: Bool = false
    @Published var isDeleteAccountAlertPresented: Bool = false

    let signOutAlert: AlertInfo = .init(
        title: "Sign Out",
        description: "Are you sure you want to sign out?"
    )

    let deleteAccountAlert: AlertInfo = .init(
        title: "Delete Account",
        description: "Are you sure you want to sign out?"
    )
}
