//
//  AuthRepository.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 23.11.2023.
//

import Foundation

class AuthRepository {
    static let shared = AuthRepository()
    
    private init() {}
    
    private let authResponseKey = "AuthResponse"


    // MARK: - User Defaults
    
    func saveResponse(_ response: AuthResponse) {
        if let encodedResponse = try? JSONEncoder().encode(response) {
            UserDefaults.standard.set(encodedResponse, forKey: authResponseKey)
        }
    }

    func getResponse() -> AuthResponse? {
        if let savedAuthResponse = UserDefaults.standard.data(forKey: authResponseKey),
           let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: savedAuthResponse) {
            return authResponse
        }
        return nil
    }

    func deleteResponse() {
        UserDefaults.standard.removeObject(forKey: authResponseKey)
    }
}
