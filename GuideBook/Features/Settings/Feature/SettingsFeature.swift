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
import KeychainSwift

struct SettingsFeature: Reducer {
    struct State: Equatable {
        var user: UserInfo?
        @PresentationState var alert: AlertState<Action.Alert>?
        var authState = AuthFeature.State()
    }
    
    enum Action: Equatable {
        case alert(PresentationAction<Alert>)

        case signOutButtonTapped
        case deleteButtonTapped
        
        case signOut
                
        enum Alert: Equatable {
            case confirmSignOutTapped
            case confirmDeleteTapped
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .alert(.presented(.confirmSignOutTapped)):
                state.alert = AlertState { TextState("Signed out!") }
                return .send(.signOut)
            case .signOut:
                deleteAuthResponse()
                return .none
            case .alert(.presented(.confirmDeleteTapped)):
                state.alert = AlertState { TextState("Account has been successfuly deleted!") }
                return .none
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
            }
        }
        .ifLet(\.$alert, action: /Action.alert)
    }
    
//    private func saveAuthResponse(response: AuthResponse) {
//        if let authResponseData = try? JSONEncoder().encode(response) {
//            keychain.set(authResponseData, forKey: "AuthResponse")
//        }
//    }
//    
//    private func getAuthResponse() -> AuthResponse? {
//        if let authResponseData = keychain.getData("AuthResponse"),
//           let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: authResponseData) {
//            return authResponse
//        }
//        return nil
//    }
//    
//    private func getToken() -> String? {
//        let response = getAuthResponse()
//        return response?.accessToken
//    }
//    
//    private func eraseAuthResponse() {
//        keychain.delete("AuthResponse")
//    }
    
    func deleteAuthResponse() {
        UserDefaults.standard.removeObject(forKey: "AuthResponse")
    }
}
