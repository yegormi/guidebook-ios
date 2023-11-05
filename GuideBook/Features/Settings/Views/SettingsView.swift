import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var settingsVM: SettingsViewModel

    @AppStorage("isOnNotifications") var isOnNotifications: Bool = false
    @AppStorage("isOnSafeSearch") var isOnSafeSearch: Bool = false
    @AppStorage("selectedMode") var selectedMode: Appearance = .auto

    private var preferredColorSchemeForSelectedMode: ColorScheme? {
        switch selectedMode {
        case .light:
            .light
        case .auto:
            nil
        case .dark:
            .dark
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    profileSection
                }
                Section(header: Text("Preferences")) {
                    colorModeToggle
                    notificationsToggle
                    safeSearchToggle
                }
                Section(header: Text("Account")) {
                    signOutButton
                    deleteAccountButton
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .pickerStyle(.segmented)
        }
        .preferredColorScheme(preferredColorSchemeForSelectedMode)
        .alert(settingsVM.signOutAlert.title,
               isPresented: $settingsVM.isSignOutAlertPresented)
        {
            Button("Cancel", role: .cancel) {}
            Button("Confirm", role: .destructive) {
                authVM.signOut()
            }
        } message: {
            Text(settingsVM.signOutAlert.description)
        }
        .alert(settingsVM.deleteAccountAlert.title,
               isPresented: $settingsVM.isDeleteAccountAlertPresented)
        {
            Button("Cancel", role: .cancel) {}
            Button("Confirm", role: .destructive) {
                authVM.deleteAccount()
            }
        } message: {
            Text(settingsVM.deleteAccountAlert.description)
        }
    }
}

extension SettingsView {
    private var profileSection: some View {
        ProfileCardStyle(card: authVM.userInfo ?? UserInfoResponse(id: "1", username: "No user found", email: "No email found"))
    }

    private var colorModeToggle: some View {
        HStack {
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

    private var notificationsToggle: some View {
        Toggle("Notifications", isOn: $isOnNotifications)
    }

    private var safeSearchToggle: some View {
        Toggle("Safe Search", isOn: $isOnSafeSearch)
    }

    private var signOutButton: some View {
        Button("Sign Out") {
            settingsVM.isSignOutAlertPresented = true
        }
        .foregroundStyle(.red)
    }

    private var deleteAccountButton: some View {
        Button("Delete Account") {
            settingsVM.isDeleteAccountAlertPresented = true
        }
        .foregroundStyle(.red)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(GuideViewModel())
            .environmentObject(AuthViewModel())
            .environmentObject(SettingsViewModel())
    }
}
