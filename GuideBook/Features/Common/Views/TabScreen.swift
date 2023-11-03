import SwiftUI


// MARK: - BODY

struct TabScreen: View {
    @State private var willShowHeader: Bool = false

    var body: some View {
        VStack {
            if willShowHeader {
                HeaderView()
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
