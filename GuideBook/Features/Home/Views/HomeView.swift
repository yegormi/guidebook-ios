//
//  HomeView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 25.10.2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var guideVM: GuideViewModel
    @EnvironmentObject var authVM: AuthViewModel

    @State private var isPerformed: Bool = false

    private var emptyDetails: GuideDetails = .init(
        id: "",
        emoji: "",
        title: "",
        description: "",
        image: "",
        authorId: "",
        author: Author(username: ""),
        isFavorite: false
    )

    var body: some View {
        let isGuidesEmpty: Bool = guideVM.filteredGuides.isEmpty
        let isSearchEmpty: Bool = guideVM.searchText.isEmpty

        NavigationView {
            if isGuidesEmpty, !isSearchEmpty {
                nothindFound
            } else {
                guidesList
            }
        }
        .searchable(text: $guideVM.searchText)
        .onAppear {
            if !isPerformed {
                guideVM.fetchGuides(token: authVM.response?.accessToken ?? "")
                isPerformed = true
            }

            if authVM.userInfo == nil {
                authVM.getUser()
            }
        }
        .refreshable {
            guideVM.guides = []
            guideVM.fetchGuides(token: authVM.response?.accessToken ?? "")
        }
    }
}

extension HomeView {
    private func getDetails(for guide: Guide) {
        guideVM.resetGuideDetails()
        guideVM.resetGuideSteps()
        guideVM.fetchGuideDetails(id: guide.id, token: authVM.response?.accessToken ?? "")
        guideVM.fetcnGuideSteps(id: guide.id, token: authVM.response?.accessToken ?? "")
    }

    private var nothindFound: some View {
        VStack {
            Spacer()
            Image(systemName: "menucard")
                .font(.system(size: 100))
                .opacity(0.3)
            Text("Nothing found")
                .font(.system(size: 24, weight: .light))
                .opacity(0.5)
            Spacer()
        }
    }

    private var guidesList: some View {
        List(guideVM.filteredGuides) { guide in
            NavigationLink(destination: GuideDetailsStyle(item: guideVM.guideDetails ?? emptyDetails)
                .onAppear { getDetails(for: guide) }
            ) { GuideStyle(item: guide) }
        }
        .listStyle(.insetGrouped)
        .navigationBarTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
    }

//    private var guidesListNEW: some View {
//        GuidesListStyles(
//            guides: guideVM.guides,
//            guideDetails: guideVM.guideDetails ?? emptyDetails,
//            title: "Home",
//            onAppear: { guide in
//                getDetails(for: guide)
//            })
//    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(GuideViewModel())
            .environmentObject(AuthViewModel())
    }
}
