//
//  HomeMain.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 27.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct HomeMainView: View {
    let store: StoreOf<HomeMain>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List(viewStore.guides) { guide in
                GuideView(item: guide)
            }
            .navigationTitle(Tab.home.rawValue)
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
                    try await Task.sleep(nanoseconds: 200_000_000)
                    await viewStore.send(.searchQueryChangeDebounced).finish()
                } catch {}
            }
        }
        
    }
}

@Reducer
struct HomeMain: Reducer {
    @Dependency(\.keychainClient) var keychainClient
    @Dependency(\.guideClient) var guideClient
    
    struct State: Equatable {
        var viewDidAppear = false
        var searchQuery   = ""
        var guides: [Guide]
    }
    
    enum Action: Equatable {
        case onAppear
        
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        
        case searchGuides
        case onSearchGuidesSuccess([Guide])
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear :
                state.viewDidAppear = true
                return .send(.searchGuides)
            case .searchGuides:
                return .run { [query = state.searchQuery] send in
                    do {
                        let guides = try await searchGuides(query: query)
                        await send(.onSearchGuidesSuccess(guides))
                    } catch {
                        print(error)
                    }
                }
            case let .onSearchGuidesSuccess(guides):
                state.guides = guides
                return .none
            case let .searchQueryChanged(query):
                state.searchQuery = query
                return .none
            case .searchQueryChangeDebounced:
                return .send(.searchGuides)
            }
        }
    }
    
    private func searchGuides(query: String) async throws -> [Guide] {
        let token = keychainClient.retrieveToken()?.accessToken ?? ""
        return try await guideClient.searchGuides(token: token, query: query)
    }
}
