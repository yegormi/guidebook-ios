//
//  FavoritesMain.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 27.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct FavoritesMainView: View {
    let store: StoreOf<FavoritesMain>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List(viewStore.favorites) { guide in
                GuideView(item: guide)
            }
            .navigationTitle(Tab.favorites.rawValue)
            .onAppear {
                if !viewStore.viewDidAppear {
                    viewStore.send(.onAppear)
                }
            }
        }
        
    }
}

@Reducer
struct FavoritesMain: Reducer {
    @Dependency(\.keychainClient) var keychainClient
    @Dependency(\.guideClient) var guideClient
    
    struct State: Equatable {
        var viewDidAppear = false
        var favorites: [Guide]
    }
    
    enum Action: Equatable {
        case onAppear
        
        case fetchFavorites
        case onFetchFavoritesSuccess([Guide])
    }
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear :
                state.viewDidAppear = true
                return .send(.fetchFavorites)
            case .fetchFavorites:
                return .run { send in
                    do {
                        let favorites = try await fetchFavorites()
                        await send(.onFetchFavoritesSuccess(favorites))
                    } catch {
                        print(error)
                    }
                }
            case let .onFetchFavoritesSuccess(guides):
                state.favorites = guides
                return .none
            }
        }
    }
    
    private func fetchFavorites() async throws -> [Guide] {
        let token = keychainClient.retrieveToken()?.accessToken ?? ""
        return try await guideClient.fetchFavorites(token: token)
    }
}
