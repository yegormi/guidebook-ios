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
            .searchable(text: viewStore.binding(
                get: \.searchQuery,
                send: { .searchQueryChanged($0) }
            ))
            .onAppear {
                if !viewStore.viewDidAppear {
                    viewStore.send(.onAppear)
                }
            }
            .task(id: viewStore.searchQuery) {
                do {
                    try await Task.sleep(nanoseconds: 250_000_000)
                    await viewStore.send(.searchQueryChangeDebounced).finish()
                } catch {}
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
        var searchQuery: String = ""
        var favorites: [Guide]
    }
    
    enum Action: Equatable {
        case onAppear
        
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        
        case searchFavorites
        case onSearchFavoritesSuccess([Guide])
    }
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear :
                state.viewDidAppear = true
                return .send(.searchFavorites)
            case .searchFavorites:
                return .run { [query = state.searchQuery] send in
                    do {
                        let guides = try await searchFavorites(query: query)
                        await send(.onSearchFavoritesSuccess(guides))
                    } catch {
                        print(error)
                    }
                }
            case let .onSearchFavoritesSuccess(guides):
                state.favorites = guides
                return .none
            case let .searchQueryChanged(query):
                state.searchQuery = query
                return .none
            case .searchQueryChangeDebounced:
                return .send(.searchFavorites)
            }
        }
    }
    
    private func searchFavorites(query: String) async throws -> [Guide] {
        let token = keychainClient.retrieveToken()?.accessToken ?? ""
        return try await guideClient.searchFavorites(token: token, query: query)
    }
}
