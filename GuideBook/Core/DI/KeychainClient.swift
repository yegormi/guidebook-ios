//
//  KeychainClient.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 28.11.2023.
//

import KeychainSwift
import ComposableArchitecture
import Foundation
import Alamofire

@DependencyClient
struct KeychainClient {
    var saveToken:     @Sendable (AuthResponse) -> Void
    var retrieveToken: @Sendable () -> AuthResponse?
    var deleteToken:   @Sendable () -> Void
}

extension DependencyValues {
    var keychainClient: KeychainClient {
        get { self[KeychainClient.self] }
        set { self[KeychainClient.self] = newValue }
    }
}

extension KeychainClient: DependencyKey, TestDependencyKey {
    static let keychainKey = "Token"

    /// Live implementation for production use
    static let liveValue = Self(
        saveToken: { response in
            let keychain = KeychainSwift()
            do {
                let authResponseData = try JSONEncoder().encode(response)
                keychain.set(authResponseData, forKey: keychainKey)
            } catch {
                print("Error saving token with: \(error)")
            }
        },
        retrieveToken: {
            let keychain = KeychainSwift()
            if let authResponseData = keychain.getData(keychainKey),
               let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: authResponseData) {
                return authResponse
            }
            return nil
        },
        deleteToken: {
            let keychain = KeychainSwift()
            keychain.delete(keychainKey)
        }
    )

    /// Test implementation with no-op functions
    static let testValue = Self()
}
