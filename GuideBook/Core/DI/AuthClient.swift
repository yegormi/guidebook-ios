//
//  AuthClient.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 28.11.2023.
//

import Alamofire
import ComposableArchitecture
import Foundation

// MARK: - API client interface

// Typically this interface would live in its own module, separate from the live implementation.
// This allows the search feature to compile faster since it only depends on the interface.

@DependencyClient
struct AuthClient {
    var performSignIn: @Sendable (String, String) async throws -> AuthResponse
    var performSignUp: @Sendable (String, String, String) async throws -> AuthResponse
    var performDelete: @Sendable () async throws -> UserDelete
    var performGetSelf: @Sendable () async throws -> UserInfo
}

extension DependencyValues {
    var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}

// MARK: - Live API implementation

extension AuthClient: DependencyKey, TestDependencyKey {
    @Dependency(\.sessionClient) static var sessionClient
    static let session = sessionClient.current
    
    static let liveValue = AuthClient(
        performSignIn: { email, password in
            let signInRequest = SignIn(email: email, password: password)
            let endpoint = "/auth/signin"

            return try await withCheckedThrowingContinuation { continuation in
                session.request(Self.baseUrl + endpoint,
                           method: .post,
                           parameters: signInRequest,
                           encoder: JSONParameterEncoder.default)
                    .validate()
                    .responseDecodable(of: AuthResponse.self) { response in
                        handleResponse(response, continuation)
                    }
            }
        },
        performSignUp: { username, email, password in
            let signUpRequest = SignUp(username: username, email: email, password: password)
            let endpoint = "/auth/signup"

            return try await withCheckedThrowingContinuation { continuation in
                session.request(Self.baseUrl + endpoint,
                           method: .post,
                           parameters: signUpRequest,
                           encoder: JSONParameterEncoder.default)
                    .validate()
                    .responseDecodable(of: AuthResponse.self) { response in
                        handleResponse(response, continuation)
                    }
            }
        },
        performDelete: {
            let endpoint = "/self"

            return try await withCheckedThrowingContinuation { continuation in
                session.request(Self.baseUrl + endpoint,
                           method: .delete)
                    .validate()
                    .responseDecodable(of: UserDelete.self) { response in
                        handleResponse(response, continuation)
                    }
            }
        },
        performGetSelf: {
            let endpoint = "/self"

            return try await withCheckedThrowingContinuation { continuation in
                session.request(Self.baseUrl + endpoint,
                           method: .get)
                    .validate()
                    .responseDecodable(of: UserInfo.self) { response in
                        handleResponse(response, continuation)
                    }
            }
        }
    )
}

// MARK: - Test Implementation

extension AuthClient {
    static let testValue = Self()
}

// MARK: - Helpers

extension AuthClient {
    static let baseUrl = Helpers.baseUrl
}

private func handleResponse<T>(_ response: AFDataResponse<T>, _ continuation: CheckedContinuation<T, Error>) {
    switch response.result {
    case let .success(value):
        continuation.resume(returning: value)
    case let .failure(error):
        if let data = response.data,
           let failResponse = try? JSONDecoder().decode(FailResponse.self, from: data)
        {
            continuation.resume(throwing: ErrorResponse.failedWithResponse(failResponse))
        } else {
            continuation.resume(throwing: error)
        }
    }
}
