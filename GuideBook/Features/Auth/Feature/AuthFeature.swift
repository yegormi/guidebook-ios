//
//  AuthFeature.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 05.11.2023.
//

import Foundation
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
            !username.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && password == confirmPassword
        }
        
        var isLoginAllowed: Bool {
            authType == .signIn ? isAbleToSignIn : isAbleToSignUp
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
        
        case saveToken(AuthResponse)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .usernameChanged(current):
                state.username = current
                state.usernameError = nil
                return .none
            case let .emailChanged(current):
                state.email = current
                state.emailError = nil
                return .none
            case let .passwordChanged(current):
                state.password = current
                state.passwordError = nil
                return .none
            case let .confirmPasswordChanged(current):
                state.confirmPassword = current
                return .none
            case .toggleButtonTapped:
                state.authType = state.authType == .signIn ? .signUp : .signIn
                state.failResponse = nil
                return .none
            case .authButtonTapped:
                let username = state.username
                let email = state.email
                let password = state.password
                
                state.isLoading = true
                
                if !isValidUsername(with: state.username) && state.authType == .signUp {
                    state.usernameError = "Invalid username"
                    state.isLoading = false
                    return .none
                }
                if !isValidEmail(with: state.email) {
                    state.emailError = "Invalid email"
                    state.isLoading = false
                    return .none
                }
                
                switch state.authType {
                case .signIn:
                    return .run { send in
                        do {
                            let result = try await performSignIn(
                                email: email,
                                password: password
                            )
                            await send(.authSuccessful(result))
                        } catch let ErrorResponse.failedWithResponse(result){
                            await send(.authFail(result))
                        } catch {
                            print(error)
                        }
                    }
                case .signUp:
                    return .run { send in
                        do {
                            let result = try await performSignUp(
                                username: username,
                                email: email,
                                password: password
                            )
                            await send(.authSuccessful(result))
                        } catch let ErrorResponse.failedWithResponse(result){
                            await send(.authFail(result))
                        } catch {
                            print(error)
                        }
                    }
                }
            case let .authSuccessful(response):
                state.response = response
                state.failResponse = nil
                state.isLoading = false
                return .send(.saveToken(response))
            case let .saveToken(response):
                saveAuthResponse(response: response)
                return .none
                
            case let .authFail(response):
                state.failResponse = response
                state.isLoading = false
                
                state.usernameError = nil
                state.emailError = nil
                state.passwordError = nil
                
                switch response.code {
                case RequestError.usernameNotUnique.code:
                    state.usernameError = RequestError.usernameNotUnique.string
                case RequestError.userNotFound.code:
                    state.emailError = RequestError.userNotFound.string
                case RequestError.emailNotUnique.code:
                    state.emailError = RequestError.emailNotUnique.string
                case RequestError.invalidPassword.code:
                    state.passwordError = RequestError.invalidPassword.string
                default:
                    break
                }
                
                return .none
            }
        }
    }
    
    func isValidUsername(with username: String) -> Bool {
        let regex = "^[a-zA-Z0-9_-]+$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: username)
    }
    
    func isValidEmail(with email: String) -> Bool {
        let regex = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
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
                case let .success(authResponse):
                    continuation.resume(returning: authResponse)
                case let .failure(error):
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
    
    // MARK: - User Defaults Functions
    
    func saveAuthResponse(response: AuthResponse) {
        if let authResponseData = try? JSONEncoder().encode(response) {
            UserDefaults.standard.set(authResponseData, forKey: "AuthResponse")
        }
    }
}

