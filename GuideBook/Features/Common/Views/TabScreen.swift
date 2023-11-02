import SwiftUI


// MARK: - BODY

struct TabScreen: View {
    @EnvironmentObject var guideVM: GuideViewModel
    @EnvironmentObject var authVM: AuthViewModel
    
    @State private var willShowHeader: Bool = false
    
    let hasNotch: Bool = UIDevice.current.hasNotch
    
    var body: some View {
        VStack {
            if willShowHeader {
                HStack {
                    headerSection
                        .padding(.leading, 20)
                        .padding(.top, hasNotch ? 0 : 10)
                    Spacer()
                    if guideVM.isStepsPresented {
                        dismissButton
                    }
                }
            }
            TabView() {
                HomeView()
                    .tabItem { Label("Home", systemImage: "house") }
                FavoritesView()
                    .tabItem { Label("Favorites", systemImage: "heart") }
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gearshape") }
            }
            .onAppear {
                withAnimation(.interactiveSpring) {
                    willShowHeader = true
                }
            }
        }
    }
}


// MARK: - PREVIEWS

struct TabScreen_Previews: PreviewProvider {
    static var previews: some View {
        TabScreen()
            .environmentObject(GuideViewModel())
            .environmentObject(AuthViewModel())
            .environmentObject(FavoritesViewModel())
            .environmentObject(SettingsViewModel())
    }
}

// MARK: - COMPONENTS

extension TabScreen {
    private var headerSection: some View {
        Text("📘 GuideBook")
            .font(.system(size: 20))
            .bold()
    }
    
    private var dismissButton: some View {
        Button(action: {
            guideVM.isStepsPresented = false
        }) {
            Image(systemName: "xmark")
                .font(.system(size: 40))
                .foregroundColor(.primary)
        }
    }
}
