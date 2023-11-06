//
//  AuthFeature.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 05.11.2023.
//

import SwiftUI
import ComposableArchitecture
import Alamofire

struct AuthFeature: Reducer {
    struct State: Equatable {
        var username: String = ""
        var email: String = ""
        var password: String = ""
        var confirmPassword: String = ""
        
        var usernameError: String?
        var emailError: String?
        var passwordError: String?
        
        var authType: AuthType = .signIn
        var isLoading: Bool = false
        var response: AuthResponse?
        var failResponse: FailResponse?
        
        var isAbleToSignIn: Bool {
            !email.isEmpty && !password.isEmpty
        }
        var isAbleToSignUp: Bool {
            !username.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
        }
        
        var isLoginAllowed: Bool {
            isAbleToSignIn || isAbleToSignUp
        }
        
    }
    
    enum Action: Equatable {
        case usernameChanged(String)
        case emailChanged(String)
        case passwordChanged(String)
        case confirmPasswordChanged(String)
        
        case toggleButtonTapped
        case authButtonTapped
        
        case authSuccessful(AuthResponse)
        case authFail(FailResponse)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .usernameChanged(let current):
            state.username = current
            return .none
        case .emailChanged(let current):
            state.email = current
            return .none
        case .passwordChanged(let current):
            state.password = current
            return .none
        case .confirmPasswordChanged(let current):
            state.confirmPassword = current
            return .none
        case .toggleButtonTapped:
            state.authType = state.authType == .signIn ? .signUp : .signIn
            return .none
        case .authButtonTapped:
            let email = state.email
            let password = state.password
            state.isLoading = true
            
            switch state.authType {
            case .signIn:
                return .run { send in
                    do {
                        let result = try await performSignIn(
                            email: email,
                            password: password
                        )
                        await send(.authSuccessful(result))
                    } catch ErrorResponse.failedWithResponse(let result){
                        await send(.authFail(result))
                    } catch {
                        print(error)
                    }
                }
            case .signUp:
                let username = state.username
                
                return .run { send in
                    do {
                        let result = try await performSignUp(
                            username: username,
                            email: email,
                            password: password
                        )
                        await send(.authSuccessful(result))
                    } catch ErrorResponse.failedWithResponse(let result){
                        await send(.authFail(result))
                    } catch {
                        print(error)
                    }
                }
            }
        case .authSuccessful(let response):
            state.response = response
            state.failResponse = nil
            state.isLoading = false
            return .none
        case .authFail(let response):
            state.failResponse = response
            state.isLoading = false
            resetErrors(&state)
            
            switch response.code {
            case RequestError.userNotFound.code:
                state.emailError = RequestError.userNotFound.string
            case RequestError.emailNotUnique.code:
                state.emailError = RequestError.emailNotUnique.string
            case RequestError.invalidPassword.code:
                state.passwordError = RequestError.invalidPassword.string
            case RequestError.usernameNotUnique.code:
                state.usernameError = RequestError.usernameNotUnique.string
            default:
                break
            }
            
            return .none
        }
    }
    
    func resetErrors(_ state: inout State) {
        state.usernameError = nil
        state.emailError = nil
        state.passwordError = nil
    }
    
    func performSignIn(email: String, password: String) async throws -> AuthResponse {
        let signInRequest = SignIn(email: email, password: password)
        let baseUrl = "https://guidebook-api.azurewebsites.net"
        let endpoint = "/auth/signin"
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(baseUrl + endpoint,
                       method: .post,
                       parameters: signInRequest,
                       encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: AuthResponse.self) { response in
                switch response.result {
                case .success(let authResponse):
                    continuation.resume(returning: authResponse)
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
    }
    
    
    func performSignUp(username: String, email: String, password: String) async throws -> AuthResponse {
        let signUpRequest = SignUp(username: username, email: email, password: password)
        let baseUrl = "https://guidebook-api.azurewebsites.net"
        let endpoint = "/auth/signup"
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(baseUrl + endpoint,
                       method: .post,
                       parameters: signUpRequest,
                       encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: AuthResponse.self) { response in
                switch response.result {
                case .success(let authResponse):
                    continuation.resume(returning: authResponse)
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
    }
}

