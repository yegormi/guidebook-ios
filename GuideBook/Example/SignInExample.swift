import SwiftUI

struct SignInExample: View {
    @State private var accessToken: String = ""

    var body: some View {
        VStack {
            Button(action: {
                // Create a sign-in request
                let signInRequest = SignInRequest(email: "yehormy@gmail.com", password: "12345")

                // Create a URL for the sign-in endpoint
                let signInURL = URL(string: "https://guidebook-api.azurewebsites.net/auth/signin")!

                var request = URLRequest(url: signInURL)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")

                do {
                    // Encode the sign-in request and set the HTTP body
                    let signInData = try JSONEncoder().encode(signInRequest)
                    request.httpBody = signInData
                } catch {
                    print("Error encoding sign-in request: \(error)")
                    return
                }

                // Perform the sign-in request
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Sign-In Error: \(error)")
                        return
                    }

                    if let data = data, let signInResponse = try? JSONDecoder().decode(AuthResponse.self, from: data) {
                        // Store the access token
                        self.accessToken = signInResponse.accessToken
                        print("Sign-In Success. Access Token: \(self.accessToken)")
                    } else {
                        print("Invalid sign-in response")
                    }
                }.resume()
            }) {
                Text("Sign in")
            }
            .buttonStyle(RoundedButtonStyle())
            .frame(width: 300, height: 100)
            
            Button(action: {
                performGetRequest()
            }) {
                Text("Get Guides")
            }
            .buttonStyle(RoundedButtonStyle())
            .frame(width: 300, height: 100)

            
        }
    }
    func performGetRequest() {
        // Create a URL for the GET request
        let baseURL = "https://guidebook-api.azurewebsites.net"
        let guidesURL = URL(string: "\(baseURL)/search/guides")!

        var getRequest = URLRequest(url: guidesURL)

        // Set the access token in the authorization header
        getRequest.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")

        // Perform the GET request
        URLSession.shared.dataTask(with: getRequest) { data, response, error in
            if let error = error {
                print("GET Request Error: \(error)")
                return
            }

            if let data = data {
                // Process the data from the GET request
                // You can decode and handle the response data here
                print("GET Request Success. Response Data:\n\(String(data: data, encoding: .utf8) ?? "N/A")")
            } else {
                print("Invalid GET response")
            }
        }.resume()
    }
}

struct SignInExample_Previews: PreviewProvider {
    static var previews: some View {
        SignInExample()
    }
}

struct RoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.blue)
            )
            .foregroundColor(Color.white)
            .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}
