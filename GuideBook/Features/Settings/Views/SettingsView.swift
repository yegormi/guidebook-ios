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
    
    @AppStorage("selectedMode") var selectedMode: Appearance = .auto
    
    private var colorSchemeOption: ColorScheme? {
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
            }
            .preferredColorScheme(colorSchemeOption)
            .pickerStyle(.segmented)
            .alert(
                store: self.store.scope(state: \.$alert, action: { .alert($0) })
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            store: Store(initialState: SettingsFeature.State()) {
                SettingsFeature()
                    ._printChanges()
            }
        )
    }
}
