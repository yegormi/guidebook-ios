import Foundation
import KeychainSwift

class AuthService {

    // MARK: Singleton
    static let shared = AuthService()

    // MARK: Keychain
    private let keychain = KeychainSwift()
    private let keychainKey = "Token"

    // MARK: - Save
    func saveToken(with response: AuthResponse) {
        do {
            let authResponse = try JSONEncoder().encode(response)
            keychain.set(authResponse, forKey: keychainKey)
        } catch {
            print("Error saving auth response: \(error)")
        }
    }

    // MARK: - Retrieve
    func retrieveToken() -> AuthResponse? {
        if let authResponseData = keychain.getData(keychainKey),
            let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: authResponseData) {
            return authResponse
        }
        return nil
    }

    // MARK: - Delete
    func deleteToken() {
        keychain.delete(keychainKey)
    }
}
