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
        
        var isLoggedIn: Bool = false
        var authType: AuthType = .signIn
        var isLoading: Bool = false
        var response: AuthResponse?
        var failResponse: FailResponse?
        
        var isAbleToSignIn: Bool {
            !email.isEmpty && !password.isEmpty
        }
        var isAbleToSignUp: Bool {
            !username.isEmpty && !email.isEmpty && 
            !password.isEmpty && !confirmPassword.isEmpty &&
            password == confirmPassword
        }
        
        var isLoginAllowed: Bool {
            authType == .signIn ? isAbleToSignIn && !isLoading : isAbleToSignUp && !isLoading
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
                state.emailError = nil
                state.usernameError = nil
                state.passwordError = nil
                return .none
            case .authButtonTapped:
                let username = state.username
                let email = state.email
                let password = state.password
                
                state.isLoading = true
                
                if !Validation.isValidUsername(with: state.username) && state.authType == .signUp {
                    state.usernameError = "Invalid username"
                    state.isLoading = false
                    return .none
                }
                if !Validation.isValidEmail(with: state.email) {
                    state.emailError = "Invalid email"
                    state.isLoading = false
                    return .none
                }
                
                switch state.authType {
                case .signIn:
                    return .run { send in
                        do {
                            let result = try await signIn(
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
                            let result = try await signUp(
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
                AuthService.shared.saveToken(with: response)
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
    
    private func signIn(email: String, password: String) async throws -> AuthResponse {
        return try await AuthAPI.shared.performSignIn(email: email, password: password)
    }
    
    private func signUp(username: String, email: String, password: String) async throws -> AuthResponse {
        return try await AuthAPI.shared.performSignUp(username: username, email: email, password: password)
    }
}

