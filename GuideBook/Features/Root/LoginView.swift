import SwiftUI

class Model: ObservableObject {
    @Published var loggedIn = false
}

struct ContentView: View {
    @ObservedObject var model = Model()

    var body: some View {
        VStack {
            if model.loggedIn {
                HomeViewSample().transition(.opacity)
            } else {
                LogInView(model: model)
            }
        }
    }
}

struct HomeViewSample: View {
    var body: some View {
        Text("Home Page")
    }
}

struct LogInView: View {
    @ObservedObject var model: Model

    var body: some View {
        VStack {
            Text("Welcome to Mamoot!")
                .font(.largeTitle)
                .fontWeight(.heavy)
            Text("We are glad to have you here.")
            Text("Please log in with your Mastodon or Twitter account to continue.")
                .multilineTextAlignment(.center)
                .lineLimit(4)
                .padding()
            Spacer()
            //            FloatingTextField(title: "Username", placeholder: "Username", width: 300, type: "Username")
            //            FloatingTextField(title: "Password", placeholder: "Password", width: 300, type: "password")
            //                .padding(.top, -50)
            Spacer()
            ZStack {
                Button(action: {
                    self.model.loggedIn = true
                }) {
                    Text("Log in")
                        .foregroundColor(Color.white)
                        .bold()
                        .shadow(color: .red, radius: 10)
                        // moved modifiers here, so the whole button is tappable
                        .padding(.leading, 140)
                        .padding(.trailing, 140)
                        .padding(.top, 15)
                        .padding(.bottom, 15)
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
            .padding(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
