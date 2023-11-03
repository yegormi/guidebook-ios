//
//  AuthVIewModelNEW.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 31.10.2023.
//

import Foundation

final class AuthViewModel: ObservableObject {
    @Published var username: String = "" {
        didSet {
            resetErrorResponse()
            isWarningsShown = false
        }
    }
    @Published var email: String = "" {
        didSet {
            resetErrorResponse()
            isWarningsShown = false
            showErrorEmail = false
        }
    }
    @Published var password: String = "" {
        didSet {
            resetErrorResponse()
            isWarningsShown = false
        }
    }
    @Published var confirmPassword: String = "" {
        didSet {
            resetErrorResponse()
            isWarningsShown = false
        }
    }
   
    
    @Published var response:      AuthResponse?
    @Published var userInfo:      UserInfoResponse?
    @Published var errorResponse: ErrorResponse?
    
    @Published var isSignIn: Bool = true
    @Published var didLoginButtonClicked: Bool = false
    @Published var shouldNavigateToHomeView: Bool = false
    @Published var shouldLogOut: Bool = false
    @Published var isRequestInProgress: Bool = false
    @Published var isSessionExpiredAlertPresented: Bool = false
    @Published var isWarningsShown: Bool = false
    @Published var showErrorEmail: Bool = false
    
    
    let sessionExpiredAlert: AlertInfo = AlertInfo(
        title: "Session Expired",
        description: "Please sign in again."
    )
    
    init() {
        self.retrieveAuthResponse()
    }
    
    // MARK: - Validation Methods
    
    func resetErrorResponse() {
        errorResponse = errorResponse ?? nil
    }
    
    func isUsernameValid(_ username: String) -> Bool {
        return checkRegex(for: "^[0-9a-zA-Z\\_]{7,18}$", string: username)
    }
    
    func isEmailValid(_ email: String) -> Bool {
        return checkRegex(for: "^[\\w.-]+@([\\w-]+\\.)+[\\w-]{2,4}$", string: email)
    }

    func checkRegex(for pattern: String, string: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: string, options: .caseInsensitive)
        let isMatched = regex.matches(in: string, options: [], range: NSMakeRange(0, string.count)).count > 0
        return isMatched
    }
    
    func isPasswordsMatched() -> Bool {
        return self.password == self.confirmPassword
    }
    
    // MARK: - Handling Responses
    
    func handleResponse<T: Codable>(_ result: Result<T, ErrorResponse>) {
        DispatchQueue.main.async {
            switch result {
            case .success(let response):
                self.handleSuccess(response: response)
            case .failure(let error):
                self.handleError(error: error)
            }
        }
    }
    
    private func handleSuccess<T: Codable>(response: T) {
        if let data = try? JSONEncoder().encode(response),
           let jsonString = String(data: data, encoding: .utf8) {
            print("Received response: \(jsonString)")
        } else {
            print("Received empty or invalid data")
        }
        
        if let authResponse = response as? AuthResponse {
            handleAuthSuccess(response: authResponse)
        } else if
            let userDeleteResponse = response as? UserDeleteResponse {
            handleUserDeleteSuccess(response: userDeleteResponse)
        } else if
            let userInfoResponse = response as? UserInfoResponse {
            handleUserInfoSuccess(response: userInfoResponse)
        }
    }
    
    private func handleError(error: ErrorResponse) {
        print("Code: \(error.code)\nMessage: \(error.message)")
        self.errorResponse = error
        if error.code == RequestError.tokenExpired.rawValue || error.code == RequestError.tokenInvalid.rawValue {
            triggerSessionExpired()
        }
    }
    
    private func handleAuthSuccess(response: AuthResponse) {
        self.response = response
        if !response.accessToken.isEmpty {
            saveAuthResponse(response: response)
            shouldNavigateToHomeView = true
        }
    }
    
    private func handleUserDeleteSuccess(response: UserDeleteResponse) {
        signOut()
        print("Signed out")
    }
    
    private func handleUserInfoSuccess(response: UserInfoResponse) {
        self.userInfo = response
    }
    
    // MARK: - Network Requests
    
    func getUser() {
        UserInfoAction(token: response?.accessToken ?? "")
            .call() { result in
                self.handleResponse(result)
        }
    }
    
    func signIn(authRequest: SignInRequest) {
        SignInAction(parameters: authRequest)
            .call() { result in
                self.handleResponse(result)
            }
    }
    
    func signUp(authRequest: SignUpRequest) {
        SignUpAction(parameters: authRequest)
            .call() { result in
                self.handleResponse(result)
            }
    }
    
    func deleteAccount() {
        if let token = response?.accessToken {
            UserDeleteAction(token: token)
                .call() { result in
                    self.handleResponse(result)
                }
        }
    }
    
    // MARK: - Session Management

    func clearUserData() {
        deleteAuthResponse()
        resetAuth()
    }

    func signOut() {
        clearUserData()
        shouldLogOut = true
    }
    
    func resetAuth() {
        username = ""
        email = ""
        password = ""
        confirmPassword = ""
        isSignIn = true
        didLoginButtonClicked = false
        isRequestInProgress = false
        isSessionExpiredAlertPresented = false
        response = nil
        errorResponse = nil
        userInfo = nil
    }
    
    func triggerSessionExpired() {
        self.isSessionExpiredAlertPresented = true
    }
    
    // MARK: - User Defaults
    
    func saveAuthResponse(response: AuthResponse) {
        if let authResponse = try? JSONEncoder().encode(response) {
            UserDefaults.standard.set(authResponse, forKey: "AuthResponse")
        }
    }
    
    func retrieveAuthResponse() {
        if let savedAuthResponse = UserDefaults.standard.data(forKey: "AuthResponse"),
           let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: savedAuthResponse) {
            self.response = authResponse
        }
    }
    
    func deleteAuthResponse() {
        UserDefaults.standard.removeObject(forKey: "AuthResponse")
    }
}
