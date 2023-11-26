//
//  AuthService.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 24.11.2023.
//

import Foundation
import Alamofire

class AuthAPI {
    static let shared = AuthAPI()
    
    let baseUrl = "https://guidebook-api.azurewebsites.net"

    func performSignIn(email: String, password: String) async throws -> AuthResponse {
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
                self.handleResponse(response, continuation)
            }
        }
    }
    
    func performSignUp(username: String, email: String, password: String) async throws -> AuthResponse {
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
                self.handleResponse(response, continuation)
            }
        }
    }
    
    func performDelete(with token: String) async throws -> UserDelete {
        let endpoint = "/self"
        
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(baseUrl + endpoint,
                       method: .delete,
                       headers: headers
            )
            .validate()
            .responseDecodable(of: UserDelete.self) { response in
                self.handleResponse(response, continuation)
            }
        }
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
}
