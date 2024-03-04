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
    
    private enum CancelID { case guides }
    
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
                return .send(.searchGuides)
                
            case .searchQueryChanged(let query):
                state.searchQuery = query
                return .send(.searchQueryChangeDebounced)
            case .searchQueryChangeDebounced:
                return .send(.searchGuides)
                    .debounce(id: CancelID.guides, for: 0.3, scheduler: mainQueue)
                
            case .onItemTapped:
                return .none
            }
        }
    }
    
    private func searchGuides(query: String) async throws -> [Guide] {
        return try await guideClient.searchGuides(query: query)
    }
    
    private func getDetails(id: String) async throws -> GuideDetails {
        return try await guideClient.getDetails(id: id)
    }
}
