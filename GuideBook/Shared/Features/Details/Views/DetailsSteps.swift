//
//  DetailsSteps.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 02.12.2023.
//

import SwiftUI
import ComposableArchitecture
import SkeletonUI

struct DetailsStepsView: View {
    let store: StoreOf<DetailsSteps>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Group {
                StepsPager(steps: viewStore.steps ?? [], guide: viewStore.guide)
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
    
}


@Reducer
struct DetailsSteps: Reducer {
    @Dependency(\.keychainClient) var keychainClient
    @Dependency(\.guideClient)    var guideClient
    
    struct State: Equatable {
        var guide: Guide
        var steps: [GuideStep]? = nil
    }
    
    enum Action: Equatable {
        case onAppear
        
        case getSteps
        case onSuccess([GuideStep])
    }
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .send(.getSteps)
            case .getSteps:
                return .run { [id = state.guide.id] send in
                    do {
                        let steps = try await getSteps(for: id)
                        await send(.onSuccess(steps))
                    } catch {
                        print(error)
                    }
                }
            case .onSuccess(let steps):
                state.steps = steps
                return .none
            }
        }
    }
    
    private func getSteps(for id: String) async throws -> [GuideStep] {
        let token = keychainClient.retrieveToken()?.accessToken ?? ""
        return try await guideClient.getSteps(token: token, id: id)
    }
}
