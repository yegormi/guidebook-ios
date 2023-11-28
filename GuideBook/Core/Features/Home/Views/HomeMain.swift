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
    
    struct State: Equatable {
        var viewDidAppear = false
        var guides: [Guide]
    }
    
    enum Action: Equatable {
        case onAppear
        case fetchGuides
        case onfetchGuidesSuccess([Guide])
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear :
                state.viewDidAppear = true
                return .send(.fetchGuides)
            case .fetchGuides:
                return .run { send in
                    do {
                        let guides = try await fetchGuides()
                        await send(.onfetchGuidesSuccess(guides))
                    } catch {
                        print(error)
                    }
                }
            case let .onfetchGuidesSuccess(guides):
                state.guides = guides
                return .none
            }
        }
    }
    
    private func fetchGuides() async throws -> [Guide] {
        let token = keychainClient.retrieveToken()?.accessToken ?? ""
        return try await guideClient.fetchGuides(token)
    }
}
