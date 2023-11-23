//
//  RootFeature.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//
//

import Foundation
import ComposableArchitecture
import Alamofire

struct RootFeature: Reducer {
    struct State: Equatable {
        var isLaunched = false
        var authState = AuthFeature.State()
        var tabsState = TabsFeature.State()
    }
    
    enum Action: Equatable {
        case appLaunched
        case retrieveToken
        
        case auth(AuthFeature.Action)
        case tabs(TabsFeature.Action)
        
        case signOut
        case accountDeleted
        case deleteSuccess(UserDelete)
        
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.authState, action: /Action.auth) {
            AuthFeature()
        }
        Scope(state: \.tabsState, action: /Action.tabs) {
            TabsFeature()
        }
        Reduce { state, action in
            switch action {
            case .appLaunched:
                state.isLaunched = true
                return .none
            case .retrieveToken:
                state.authState.response = retrieveAuthResponse()
                return .none
            case .auth:
                return .none
            case .tabs:
                return .none
            case .signOut:
                state.authState.response = nil
                eraseAuthResponse()
                return .none
            case .accountDeleted:
                let token = state.authState.response?.accessToken ?? ""
                state.authState.response = nil
                eraseAuthResponse()
                return .run { send in
                    do {
                        let result = try await performDelete(token: token)
                        await send(.deleteSuccess(result))
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            case let .deleteSuccess(result):
                print("\(result.message)")
                return .none
            }
        }
    }
    
    func retrieveAuthResponse() -> AuthResponse? {
        if let authResponseData = UserDefaults.standard.data(forKey: "AuthResponse"),
           let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: authResponseData) {
            return authResponse
        }
        return nil
    }
    
    func eraseAuthResponse() {
        UserDefaults.standard.removeObject(forKey: "AuthResponse")
    }
    
    func performDelete(token: String) async throws -> UserDelete {
        let baseUrl = "https://guidebook-api.azurewebsites.net"
        let endpoint = "/self"
        
        let headers: HTTPHeaders = [
            "Authorization": "\(token)"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(baseUrl + endpoint, method: .delete, headers: headers)
                .validate()
                .responseDecodable(of: UserDelete.self) { response in
                    switch response.result {
                    case .success(let deleteResponse):
                        continuation.resume(returning: deleteResponse)
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
