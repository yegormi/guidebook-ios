//
//  SettingsView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//
//

import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    let store: StoreOf<SettingsFeature>
    
    @AppStorage("isOnNotifications") var isOnNotifications: Bool = false
    @AppStorage("isOnSafeSearch") var isOnSafeSearch: Bool = false
    @AppStorage("selectedMode") var selectedMode: Appearance = .auto
    
    let signOutAlert = AlertInfo(
        title: "Sign Out",
        description: "Are you sure you want to sign out?"
    )
    
    let deleteAccountAlert = AlertInfo(
        title: "Delete Account",
        description: "Are you sure you want to sign out?"
    )
    
    private var preferredColorSchemeForSelectedMode: ColorScheme? {
        switch selectedMode {
        case .light:
            return .light
        case .auto:
            return nil
        case .dark:
            return .dark
        }
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section(header: Text("Profile")) {
                    ProfileCardStyle(card: viewStore.user ??
                                     UserInfo(id: "1", username: "No user found", email: "No email found")
                    )
                }
                Section(header: Text("Preferences")) {
                    HStack{
                        Text("Color mode")
                        Spacer()
                        Picker("Color mode", selection: $selectedMode) {
                            ForEach(Appearance.allCases) { mode in
                                Image(systemName: mode.modeImage)
                            }
                        }
                        .fixedSize()
                    }
                    Toggle("Notifications", isOn: $isOnNotifications)
                    Toggle("Safe Search", isOn: $isOnSafeSearch)
                }
                Section(header: Text("Account")) {
                    Button("Sign Out") {
                        viewStore.send(.signOutButtonTapped)
                    }
                    .foregroundStyle(.red)
                    
                    Button("Delete Account") {
                        viewStore.send(.deleteButtonTapped)
                    }
                    .foregroundStyle(.red)
                }
                .navigationBarTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .pickerStyle(.segmented)
            }
            .preferredColorScheme(preferredColorSchemeForSelectedMode)
            
            .alert(signOutAlert.title, isPresented: viewStore.binding(
                get: \.isSignOutAlertPresented,
                send: SettingsFeature.Action.signOutButtonTapped
            )) {
                Button("Cancel", role: .cancel) {
                    
                }
                Button("Confirm", role: .destructive) {
                    viewStore.send(.confirmSignOutTapped)
                }
            } message: {
                Text(signOutAlert.description)
            }
            
            .alert(deleteAccountAlert.title, isPresented: viewStore.binding(
                get: \.isDeleteAlertPresented,
                send: SettingsFeature.Action.deleteButtonTapped
            )) {
                Button("Cancel", role: .cancel) {}
                Button("Confirm", role: .destructive) {
                    viewStore.send(.confirmDeleteTapped)
                }
            } message: {
                Text(deleteAccountAlert.description)
            }
        }
    }
}
