//
//  AuthClient.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 28.11.2023.
//

import Foundation
import ComposableArchitecture
import Alamofire

// MARK: - API client interface

// Typically this interface would live in its own module, separate from the live implementation.
// This allows the search feature to compile faster since it only depends on the interface.

@DependencyClient
struct AuthClient {
    var performSignIn:  @Sendable (String, String) async throws -> AuthResponse
    var performSignUp:  @Sendable (String, String, String) async throws -> AuthResponse
    var performDelete:  @Sendable (String) async throws -> UserDelete
    var performGetSelf: @Sendable (String) async throws -> UserInfo
}

extension DependencyValues {
    var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}

// MARK: - Live API implementation

extension AuthClient: DependencyKey, TestDependencyKey {
    static let liveValue = AuthClient(
        performSignIn: { email, password in
            let signInRequest = SignIn(email: email, password: password)
            let endpoint = "/auth/signin"
            
            return try await withCheckedThrowingContinuation { continuation in
                AF.request(Self.baseUrl + endpoint,
                           method: .post,
                           parameters: signInRequest,
                           encoder: JSONParameterEncoder.default
                )
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
                AF.request(Self.baseUrl + endpoint,
                           method: .post,
                           parameters: signUpRequest,
                           encoder: JSONParameterEncoder.default
                )
                .validate()
                .responseDecodable(of: AuthResponse.self) { response in
                    handleResponse(response, continuation)
                }
            }
        },
        performDelete: { token in
            let endpoint = "/self"
            
            let headers: HTTPHeaders = [
                "Authorization": "\(token)"
            ]
            
            return try await withCheckedThrowingContinuation { continuation in
                AF.request(Self.baseUrl + endpoint,
                           method: .delete,
                           headers: headers
                )
                .validate()
                .responseDecodable(of: UserDelete.self) { response in
                    handleResponse(response, continuation)
                }
            }
        },
        performGetSelf: { token in
            let endpoint = "/self"
            
            let headers: HTTPHeaders = [
                "Authorization": "\(token)"
            ]
            
            return try await withCheckedThrowingContinuation { continuation in
                AF.request(Self.baseUrl + endpoint,
                           method: .get,
                           headers: headers
                )
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
    case .success(let value):
        continuation.resume(returning: value)
    case .failure(let error):
        if let data = response.data,
           let failResponse = try? JSONDecoder().decode(FailResponse.self, from: data) {
            continuation.resume(throwing: ErrorResponse.failedWithResponse(failResponse))
        } else {
            continuation.resume(throwing: error)
        }
    }
}
