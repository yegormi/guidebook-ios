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
        @PresentationState var alert: AlertState<Action.Alert>?
        var authState = AuthFeature.State()
    }
    
    enum Action: Equatable {
        case alert(PresentationAction<Alert>)

        case signOutButtonTapped
        case deleteButtonTapped
        
        case onSignOut
        case onDeleteAccount
        case onDeleteSuccess(UserDelete)
                
        enum Alert: Equatable {
            case confirmSignOutTapped
            case confirmDeleteTapped
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .alert(.presented(.confirmSignOutTapped)):
                return .send(.onSignOut)
            case .onSignOut:
                AuthService.shared.deleteToken()
                return .none
                
            case .alert(.presented(.confirmDeleteTapped)):
                return .send(.onDeleteAccount)
            case .onDeleteAccount:
                let token = AuthService.shared.retrieveToken()?.accessToken ?? ""
                
                return .run { send in
                    do {
                        let result = try await AuthAPI.shared.performDelete(with: token)
                        await send(.onDeleteSuccess(result))
                    } catch {
                        print(error)
                    }
                }
            case .onDeleteSuccess:
                AuthService.shared.deleteToken()
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
}
