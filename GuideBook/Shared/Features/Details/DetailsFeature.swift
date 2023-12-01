//
//  HomeDetails.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 30.11.2023.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct DetailsFeature: Reducer {
    @Dependency(\.keychainClient) var keychainClient
    @Dependency(\.guideClient) var guideClient
    
    struct State: Equatable {
        var guide: Guide
        var details: GuideDetails? = nil
    }
    
    enum Action: Equatable {
        case onAppear
        case getDetails
        case onSuccess(GuideDetails)
    }
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .send(.getDetails)
            case .getDetails:
                return .run { [id = state.guide.id] send in
                    do {
                        let details = try await getDetails(id: id)
                        await send(.onSuccess(details))
                    } catch {
                        print(error)
                    }
                }
            case .onSuccess(let details):
                state.details = details
                return .none
            }
        }
    }
    
    private func getDetails(id: String) async throws -> GuideDetails {
        let token = keychainClient.retrieveToken()?.accessToken ?? ""
        return try await guideClient.getDetails(token: token, id: id)
    }
}
