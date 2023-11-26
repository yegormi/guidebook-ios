import Foundation

class AuthService {

    // MARK: Singleton
    static let shared = AuthService()

    // MARK: UserDefaults
    private let userDefaults = UserDefaults.standard
    private let userDefaultsKey = "Token"

    // MARK: - Save
    func saveToken(with response: AuthResponse) {
        do {
            let authResponse = try JSONEncoder().encode(response)
            userDefaults.set(authResponse, forKey: userDefaultsKey)
        } catch {
            print("Error saving auth response: \(error)")
        }
    }

    // MARK: - Retrieve
    func retrieveToken() -> AuthResponse? {
        if let authResponseData = userDefaults.data(forKey: userDefaultsKey),
            let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: authResponseData) {
            return authResponse
        }
        return nil
    }

    // MARK: - Delete
    func deleteToken() {
        userDefaults.removeObject(forKey: userDefaultsKey)
    }
}
