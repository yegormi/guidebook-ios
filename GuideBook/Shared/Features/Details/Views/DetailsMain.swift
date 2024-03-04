//
//  HomeDetails.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 30.11.2023.
//

import SwiftUI
import ComposableArchitecture
import SkeletonUI
import Pow

struct DetailsMainView: View {
    let store: StoreOf<DetailsMain>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView {
                VStack {
                    ImageCard(imageURL: viewStore.details?.image ?? "")
                        .padding(.bottom, 25)
                    
                    HStack {
                        VStack(spacing: 5) {
                            HStack(spacing: 5) {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.gray)
                                    .skeleton(with: viewStore.details == nil,
                                              size: CGSize(width: 25, height: 25),
                                              shape: .circle)
                                Text(viewStore.details?.author.username)
                                    .font(.system(size: 16))
                                    .skeleton(with: viewStore.details == nil,
                                              size: CGSize(width: 80, height: 25))
                                Spacer()
                            }
                            HStack {
                                Text(viewStore.details?.title)
                                    .font(.system(size: 20))
                                    .skeleton(with: viewStore.details == nil,
                                              size: CGSize(width: 200, height: 27))
                                Spacer()
                            }
                        }
                        Button {
                            viewStore.send(.favoriteTapped)
                        } label: {
                            Image(systemName: viewStore.isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(viewStore.isFavorite ? Color.red : Color.gray)
                                .font(.system(size: 28))
                        }
                        .changeEffect(.feedbackHapticSelection, value: viewStore.isFavorite, isEnabled: viewStore.isFavorite)
                        
                    }
                    Divider()
                    
                    Text(viewStore.details?.description)
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 10)
                        .skeleton(with: viewStore.details == nil,
                                  size: CGSize(width: CGFloat.infinity, height: 90),
                                  shape: .rectangle)
                }
                .navigationBarTitle("Details")
                .navigationBarTitleDisplayMode(.inline)
                .padding(30)
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .safeAreaInset(edge: .bottom, alignment: .trailing) {
                if !viewStore.steps.isEmpty {
                    Button {
                        viewStore.send(.onStepsButtonTapped(viewStore.guide, viewStore.steps))
                    } label: {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 20))
                            .frame(width: 55, height: 55)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                    .padding([.bottom, .trailing], 15)
                }
            }
        }
    }
    
}


@Reducer
struct DetailsMain: Reducer {
    @Dependency(\.keychainClient) var keychainClient
    @Dependency(\.guideClient)    var guideClient
    
    struct State: Equatable {
        var guide: Guide
        var details: GuideDetails?
        var steps: [GuideStep] = []
        var isFavorite: Bool = false
        var response: ResponseMessage?
    }
    
    enum Action: Equatable {
        case onAppear
        
        case getDetails
        case onDetailsSuccess(GuideDetails)
        
        case getSteps
        case onStepsSuccess([GuideStep])
        
        case favoriteTapped
        case onFavoriteAction
        case onFavoriteSuccess(ResponseMessage)
        
        case addToFavorites
        case deleteFromFavorites
        
        case onStepsButtonTapped(Guide, [GuideStep])
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
                        await send(.onDetailsSuccess(details))
                    } catch {
                        print(error)
                    }
                }
            case .onDetailsSuccess(let details):
                state.details = details
                state.isFavorite = details.isFavorite
                return .send(.getSteps)
                
            case .getSteps:
                return .run { [id = state.guide.id] send in
                    do {
                        let steps = try await getSteps(for: id)
                        await send(.onStepsSuccess(steps))
                    } catch {
                        print(error)
                    }
                }
            case .onStepsSuccess(let steps):
                state.steps = steps
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
            
            case .onStepsButtonTapped:
                return .none
            }
        }
    }
    
    private func getDetails(for id: String) async throws -> GuideDetails {
        return try await guideClient.getDetails(id: id)
    }
    
    private func getSteps(for id: String) async throws -> [GuideStep] {
        return try await guideClient.getSteps(id: id)
    }
    
    private func addToFavorites(with id: String) async throws -> ResponseMessage {
        return try await guideClient.addToFavorites(id: id)
    }
    
    private func deleteFromFavorites(with id: String) async throws -> ResponseMessage {
        return try await guideClient.deleteFromFavorites(id: id)
    }
}
