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
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section(header: Text("Profile")) {
                    ProfileCardStyle(user: viewStore.user)
                }
                Section(header: Text("Preferences")) {
                    HStack{
                        Text("Color mode")
                        Spacer()
                        Picker("Color mode",
                               selection: viewStore.binding(
                                get: \.selectedMode,
                                send: { .updateSelectedMode($0) }
                               )
                        ) {
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
            .navigationTitle(Tab.settings.rawValue)
            .preferredColorScheme(viewStore.colorSchemeOption)
            .pickerStyle(.segmented)
            .onAppear {
                if !viewStore.settingsDidAppear {
                    viewStore.send(.settingsDidAppear)
                }
            }
            .alert(
                store: self.store.scope(
                    state: \.$alert,
                    action: \.alert
                )
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
