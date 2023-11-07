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
        var isSignOutAlertPresented: Bool = false
        var isDeleteAlertPresented: Bool = false
        var user: UserInfo?
        var authState = AuthFeature.State()
        var token: String {
            authState.response?.accessToken ?? ""
        }
    }
    
    enum Action: Equatable {
        case signOutButtonTapped
        case deleteButtonTapped
        
        case signOutDismissed
        case deleteDismissed
        
        case confirmSignOutTapped
        case confirmDeleteTapped
        
        case signOutSuccess
        case signOutError
        
        case deleteSuccess
        case deleteError
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .signOutButtonTapped:
            state.isSignOutAlertPresented = true
            return .none
        case .deleteButtonTapped:
            state.isDeleteAlertPresented = true
            return .none
        case .confirmSignOutTapped:
            return .none
        case .signOutDismissed:
            state.isSignOutAlertPresented = false
            return .none
        case .deleteDismissed:
            state.isDeleteAlertPresented = false
            return .none
        case .confirmDeleteTapped:
            let token = state.token
            return .run { send in
                do {
                    let result = try await performDelete(token: token)
                    await send(.deleteSuccess)
                } catch {
                    await send(.deleteError)
                }
            }
        case .signOutSuccess:
            return .none
        case .signOutError:
            return .none
        case .deleteSuccess:
            return .none
        case .deleteError:
            return .none
        }
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
