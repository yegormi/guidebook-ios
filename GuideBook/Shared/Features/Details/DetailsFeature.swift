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
    @Dependency(\.guideClient)    var guideClient
    
    struct State: Equatable {
        var guide: Guide
        var details: GuideDetails? = nil
        var isFavorite = false
        var response: ResponseMessage?
    }
    
    enum Action: Equatable {
        case onAppear
        
        case getDetails
        case onSuccess(GuideDetails)
        
        case favoriteTapped
        case onFavoriteAction
        case addToFavorites
        case deleteFromFavorites
        case onFavoriteSuccess(ResponseMessage)
    }
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .send(.getDetails)
            case .getDetails:
                return .run { [id = state.guide.id] send in
                    do {
                        let details = try await getDetails(for: id)
                        await send(.onSuccess(details))
                    } catch {
                        print(error)
                    }
                }
            case .onSuccess(let details):
                state.details = details
                state.isFavorite = details.isFavorite
                return .none
            case .favoriteTapped:
                state.isFavorite.toggle()
                return .send(.onFavoriteAction)
            case .onFavoriteAction:
                switch state.isFavorite {
                case true:
                    return .send(.addToFavorites)
                case false:
                    return .send(.deleteFromFavorites)
                }
            case .addToFavorites:
                return .run { [id = state.guide.id] send in
                    do {
                        let response = try await addToFavorites(with: id)
                        await send(.onFavoriteSuccess(response))
                    } catch {
                        print(error)
                    }
                }
            case .deleteFromFavorites:
                return .run { [id = state.guide.id] send in
                    do {
                        let response = try await deleteFromFavorites(with: id)
                        await send(.onFavoriteSuccess(response))
                    } catch {
                        print(error)
                    }
                }
            case .onFavoriteSuccess(let response):
                state.response = response
                return .none
            }
        }
    }
    
    private func getDetails(for id: String) async throws -> GuideDetails {
        let token = keychainClient.retrieveToken()?.accessToken ?? ""
        return try await guideClient.getDetails(token: token, id: id)
    }
    
    private func addToFavorites(with id: String) async throws -> ResponseMessage {
        let token = keychainClient.retrieveToken()?.accessToken ?? ""
        return try await guideClient.addToFavorites(token: token, id: id)
    }
    
    private func deleteFromFavorites(with id: String) async throws -> ResponseMessage {
        let token = keychainClient.retrieveToken()?.accessToken ?? ""
        return try await guideClient.deleteFromFavorites(token: token, id: id)
    }
}
