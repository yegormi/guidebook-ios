//
//  AuthService.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 24.11.2023.
//

import Foundation
import Alamofire

struct AuthAPI {
    static let baseUrl = "https://guidebook-api.azurewebsites.net"

    static func performSignIn(email: String, password: String) async throws -> AuthResponse {
        let signInRequest = SignIn(email: email, password: password)
        let endpoint = "/auth/signin"
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(baseUrl + endpoint,
                       method: .post,
                       parameters: signInRequest,
                       encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: AuthResponse.self) { response in
                handleResponse(response, continuation: continuation)
            }
        }
    }
    
    static func performSignUp(username: String, email: String, password: String) async throws -> AuthResponse {
        let signUpRequest = SignUp(username: username, email: email, password: password)
        let endpoint = "/auth/signup"
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(baseUrl + endpoint,
                       method: .post,
                       parameters: signUpRequest,
                       encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: AuthResponse.self) { response in
                handleResponse(response, continuation: continuation)
            }
        }
    }
    
    private static func handleResponse<T>(_ response: AFDataResponse<T>, continuation: CheckedContinuation<T, Error>) {
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
}
