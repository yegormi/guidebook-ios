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
                    .onTapGesture {
                        viewStore.send(.onGuideTapped(guide))
                    }
            }
            .listStyle(.insetGrouped)
            .transition(.move(edge: .bottom))
            .navigationTitle(Tab.favorites.rawValue)
            .searchable(text: viewStore.binding(
                get: \.searchQuery,
                send: { .searchQueryChanged($0) }
            ))
            .refreshable {
                viewStore.send(.onRefresh, animation: .default)
            }
            .onAppear {
                if !viewStore.viewDidAppear {
                    viewStore.send(.onAppear)
                }
            }
            .onChange(of: viewStore.searchQuery, perform: { query in
                viewStore.send(.searchQueryChangeDebounced)
            })
        }
        
    }
}

@Reducer
struct FavoritesMain: Reducer {
    @Dependency(\.keychainClient) var keychainClient
    @Dependency(\.guideClient) var guideClient
    @Dependency(\.mainQueue) var mainQueue
    
    struct State: Equatable {
        var viewDidAppear = false
        var searchQuery   = ""
        var favorites: [Guide]
        var details: GuideDetails?
    }
    
    enum Action: Equatable {
        case onAppear
        
        case searchFavorites
        case onSearchFavoritesSuccess([Guide])
        case onRefresh
        
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        
        case onGuideTapped(Guide)
        case onDetailsSuccess(GuideDetails)
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
                        await send(.onSearchFavoritesSuccess(guides), animation: .default)
                    } catch {
                        print(error)
                    }
                }
            case let .onSearchFavoritesSuccess(guides):
                state.favorites = guides
                return .none
            case .onRefresh:
                state.favorites = []
                return .send(.searchFavorites)
                
            case let .searchQueryChanged(query):
                state.searchQuery = query
                return .none
            case .searchQueryChangeDebounced:
                return .run { send in
                    try await mainQueue.sleep(for: .seconds(0.3))
                    await send(.searchFavorites)
                }
                
            case .onGuideTapped(let guide):
                return .run { send in
                    do {
                        let details = try await getDetails(id: guide.id)
                        await send(.onDetailsSuccess(details))
                    } catch {
                        print(error)
                    }
                }
            case .onDetailsSuccess(let details):
                state.details = details
                return .none
            }
        }
    }
    
    private func searchFavorites(query: String) async throws -> [Guide] {
        let token = keychainClient.retrieveToken()?.accessToken ?? ""
        return try await guideClient.searchFavorites(token: token, query: query)
    }
    
    private func getDetails(id: String) async throws -> GuideDetails {
        let token = keychainClient.retrieveToken()?.accessToken ?? ""
        return try await guideClient.getDetails(token: token, id: id)
    }
}
