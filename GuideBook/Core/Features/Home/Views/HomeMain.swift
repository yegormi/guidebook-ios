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
                Button {
                    viewStore.send(.onItemTapped(guide))
                } label: {
                    GuideView(item: guide)
                }
            }
            .listStyle(.insetGrouped)
            .transition(.move(edge: .bottom))
            .navigationTitle(Tab.home.rawValue)
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
            .task(id: viewStore.searchQuery) {
                do {
                    try await Task.sleep(seconds: 0.3)
                    await viewStore.send(.searchQueryChangeDebounced).finish()
                } catch {}
            }
//            .onChange(of: viewStore.searchQuery, perform: { query in
//                viewStore.send(.searchQueryChangeDebounced)
//            })
        }
        
    }
}

@Reducer
struct HomeMain: Reducer {
    @Dependency(\.keychainClient) var keychainClient
    @Dependency(\.guideClient) var guideClient
    @Dependency(\.mainQueue) var mainQueue
    
    struct State: Equatable {
        var viewDidAppear = false
        var searchQuery   = ""
        var guides: [Guide]
        var details: GuideDetails?
    }
    
    enum Action: Equatable {
        case onAppear
        
        case searchGuides
        case onSearchGuidesSuccess([Guide])
        case onRefresh
        
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        
        case onItemTapped(Guide)
    }
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear :
                state.viewDidAppear = true
                return .send(.searchGuides)
            case .searchGuides:
                return .run { [query = state.searchQuery] send in
                    do {
                        let guides = try await searchGuides(query: query)
                        await send(.onSearchGuidesSuccess(guides), animation: .default)
                    } catch {
                        print(error)
                    }
                }
            case .onSearchGuidesSuccess(let guides):
                state.guides = guides
                return .none
            case .onRefresh:
                state.guides = []
                return .send(.searchGuides)
                
            case .searchQueryChanged(let query):
                state.searchQuery = query
                return .none
            case .searchQueryChangeDebounced:
                return .run { send in
                    do {
                        try await mainQueue.sleep(for: .seconds(0.3))
                        await send(.searchGuides)
                    } catch {}
                }
                
            case .onItemTapped:
                return .none
            }
        }
    }
    
    private func searchGuides(query: String) async throws -> [Guide] {
        let token = keychainClient.retrieveToken()?.accessToken ?? ""
        return try await guideClient.searchGuides(token: token, query: query)
    }
    
    private func getDetails(id: String) async throws -> GuideDetails {
        let token = keychainClient.retrieveToken()?.accessToken ?? ""
        return try await guideClient.getDetails(token: token, id: id)
    }
}
