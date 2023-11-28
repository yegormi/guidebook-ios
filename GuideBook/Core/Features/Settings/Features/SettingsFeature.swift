//
//  SettingsFeature.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//
//

import SwiftUI
import ComposableArchitecture
import Alamofire

@Reducer
struct SettingsFeature: Reducer {
    @Dependency(\.authClient) var authClient
    @Dependency(\.keychainClient) var keychainClient
    
    struct State: Equatable {
        var user: UserInfo?
        @PresentationState var alert: AlertState<Action.Alert>?
        var token: String = ""
        var settingsDidAppear = false
        var selectedMode: Appearance = .auto
        
        var colorSchemeOption: ColorScheme? {
            switch self.selectedMode {
            case .light:
                return .light
            case .auto:
                return nil
            case .dark:
                return .dark
            }
        }
    }
    
    enum Action: Equatable {
        case alert(PresentationAction<Alert>)
        
        case signOutButtonTapped
        case deleteButtonTapped
        
        case onSignOut
        case onDeleteAccount
        case onDeleteSuccess(UserDelete)
        
        case settingsDidAppear
        case onGetSelf(UserInfo)
        
        case updateSelectedMode(Appearance)
        
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
                deleteToken()
                return .none
                
            case .alert(.presented(.confirmDeleteTapped)):
                return .send(.onDeleteAccount)
            case .onDeleteAccount:
                return .run { [token = state.token] send in
                    do {
                        let result = try await deleteAccount(with: token)
                        await send(.onDeleteSuccess(result))
                    } catch {
                        print(error)
                    }
                }
            case .onDeleteSuccess:
                deleteToken()
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
            case .settingsDidAppear:
                state.settingsDidAppear = true
                state.token = keychainClient.retrieveToken()?.accessToken ?? ""
                return .run { [token = state.token] send in
                    do {
                        let user = try await getSelf(with: token)
                        await send(.onGetSelf(user))
                    } catch {
                        print(error)
                    }
                }
            case let .onGetSelf(user):
                state.user = user
                return .none
            case let .updateSelectedMode(newMode):
                state.selectedMode = newMode
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
    
    private func getSelf(with token: String) async throws -> UserInfo {
        return try await authClient.performGetSelf(token)
    }
    
    private func deleteAccount(with token: String) async throws -> UserDelete {
        return try await authClient.performDelete(token)
    }
    
    private func deleteToken() {
        keychainClient.deleteToken()
    }
}
