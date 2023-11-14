//
//  SettingsFeature.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//
//

import Foundation
import ComposableArchitecture
import Alamofire

struct SettingsFeature: Reducer {
    struct State: Equatable {
        var user: UserInfo?
        var rootState = RootFeature.State()
        @PresentationState var alert: AlertState<Action.Alert>?
    }
    
    enum Action: Equatable {
        case alert(PresentationAction<Alert>)

        case signOutButtonTapped
        case deleteButtonTapped
        
        case deleteSuccess(UserDelete)
        
        enum Alert: Equatable {
            case confirmDeleteTapped
            case confirmSignOutTapped
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .alert(.presented(.confirmSignOutTapped)):
                state.alert = AlertState { TextState("Signed out!") }
                state.rootState.authState.response = nil
                eraseAuthResponse()
                return .none
            case .alert(.presented(.confirmDeleteTapped)):
                state.alert = AlertState { TextState("Account has been successfuly deleted!") }
                let token = state.rootState.authState.response?.accessToken ?? ""
                return .run { send in
                    do {
                        let result = try await performDelete(token: token)
                        await send(.deleteSuccess(result))
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            case .alert:
                return .none
                
            case .signOutButtonTapped:
                state.alert = AlertState {
                    TextState("Sign Out")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                    ButtonState(role: .destructive, action: .confirmSignOutTapped) {
                        TextState("Sign Out")
                    }
                } message: {
                    TextState("Are you sure you want to sign out?")
                }
                return .none
            case .deleteButtonTapped:
                state.alert = AlertState {
                    TextState("Delete Account")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                    ButtonState(role: .destructive, action: .confirmDeleteTapped) {
                        TextState("Delete")
                    }
                } message: {
                    TextState("Are you sure you want to delete your account?")
                }
                return .none
            case let .deleteSuccess(result):
                print("\(result.message)")
                return .none
            }
        }
        .ifLet(\.$alert, action: /Action.alert)
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
