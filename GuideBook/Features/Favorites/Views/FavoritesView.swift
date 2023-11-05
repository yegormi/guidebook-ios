//
//  FavoritesView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 25.10.2023.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var guideVM: GuideViewModel
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var favoritesVM: FavoritesViewModel

    var body: some View {
        NavigationView {
            Form {
                if guideVM.isFetchingFavorites {
                    ProgressView()
                } else {
                    if guideVM.favorites.isEmpty {
                        EmptyFavorites()
                    } else {
                        favoriteGuides
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $favoritesVM.searchText)
        .onAppear {
            if guideVM.shouldUpdateFavorites || !guideVM.hasFetchedFavorites {
                guideVM.fetchFavorites(token: authVM.response?.accessToken ?? "")
            }
        }
        .refreshable {
            guideVM.fetchFavorites(token: authVM.response?.accessToken ?? "")
        }
    }

    private func getDetails(for guide: Guide) {
        guideVM.resetGuideDetails()
        guideVM.resetGuideSteps()
        guideVM.fetchGuideDetails(id: guide.id, token: authVM.response?.accessToken ?? "")
        guideVM.fetcnGuideSteps(id: guide.id, token: authVM.response?.accessToken ?? "")
    }

    private var favoriteGuides: some View {
        List(guideVM.favorites) { guide in
            NavigationLink(destination: GuideDetailsStyle(item: guideVM.guideDetails ?? guideVM.emptyDetails)
                .onAppear {
                    getDetails(for: guide)
                }) {
                    GuideStyle(item: guide)
                }
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(GuideViewModel())
            .environmentObject(AuthViewModel())
            .environmentObject(FavoritesViewModel())
    }
}
