//
//  DetailsView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 30.11.2023.
//

import SwiftUI
import ComposableArchitecture
import SkeletonUI

struct DetailsView: View {
    let store: StoreOf<DetailsFeature>
    
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
                        Image(systemName: "heart")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 28))
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
        }
    }
    
}
