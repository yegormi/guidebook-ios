//
//  SessionClient.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 04.03.2024.
//

import Alamofire
import ComposableArchitecture
import Foundation
import KeychainSwift

// MARK: - API client interface

// Typically this interface would live in its own module, separate from the live implementation.
// This allows the search feature to compile faster since it only depends on the interface.

@DependencyClient
struct SessionClient {
    var current: Session
}

extension DependencyValues {
    var sessionClient: SessionClient {
        get { self[SessionClient.self] }
        set { self[SessionClient.self] = newValue }
    }
}

// MARK: - Live API implementation

extension SessionClient: DependencyKey, TestDependencyKey {
    static let liveValue = Self(
        current: {
            let interceptor = AuthInterceptor {
                @Dependency(\.keychainClient) var keychainClient
                return keychainClient.retrieveToken()?.accessToken
            }
            
            return Session(interceptor: interceptor)
        }()
    )
}

// MARK: - Test Implementation

extension SessionClient {
    static let testValue = Self(current: .default)
}
