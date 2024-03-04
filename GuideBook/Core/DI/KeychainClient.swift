//
//  KeychainClient.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 28.11.2023.
//

import Alamofire
import ComposableArchitecture
import Foundation
import KeychainSwift

// MARK: - API client interface

// Typically this interface would live in its own module, separate from the live implementation.
// This allows the search feature to compile faster since it only depends on the interface.

@DependencyClient
struct KeychainClient {
    var saveToken: @Sendable (AuthResponse) -> Void
    var retrieveToken: @Sendable () -> AuthResponse?
    var deleteToken: @Sendable () -> Void
}

extension DependencyValues {
    var keychainClient: KeychainClient {
        get { self[KeychainClient.self] }
        set { self[KeychainClient.self] = newValue }
    }
}

// MARK: - Live API implementation

extension KeychainClient: DependencyKey, TestDependencyKey {
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
               let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: authResponseData)
            {
                return authResponse
            }
            return nil
        },
        deleteToken: {
            let keychain = KeychainSwift()
            keychain.delete(keychainKey)
        }
    )
}

// MARK: - Test Implementation

extension KeychainClient {
    static let testValue = Self()
}

// MARK: - Helpres

extension KeychainClient {
    static let keychainKey = "Token"
}
