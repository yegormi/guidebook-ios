//
//  GuideDetailsStyle.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 25.10.2023.
//

import SwiftUI

struct GuideDetailsStyle: View {
    let item: GuideDetails
    
    @EnvironmentObject var guideVM: GuideViewModel
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    @EnvironmentObject var authVM: AuthViewModel
    
    @State private var isPresented: Bool = false
    @State private var isToggled: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                ImageCard(imageURL: item.image)
                    .padding(.bottom, 25)
                HStack {
                    VStack(spacing: 5) {
                        HStack(spacing: 5) {
                            profilePicture
                            authorName
                            Spacer()
                        }
                        HStack {
                            cardTitleView
                            Spacer()
                        }
                    }
                    favoriteButton
                }
                Divider()
                cardDescriptionView
                    .padding(.top, 10)
            }
            .navigationBarTitle("Details")
            .padding(30)
        }
        .safeAreaInset(edge: .bottom, alignment: .trailing) {
            if !guideVM.guideSteps.isEmpty {
                showStepsButton
                    .padding(.bottom, 15)
                    .padding(.trailing, 15)
            }
        }
        .onChange(of: item.isFavorite) { newState in
            isToggled = newState
        }
    }
}

extension GuideDetailsStyle {
    
    private var profilePicture: some View {
        Image(systemName: "person.circle.fill")
            .font(.system(size: 20))
            .foregroundColor(.gray)
    }
    
    private var authorName: some View {
        Text(item.author.username)
            .font(.system(size: 16))
    }
    
    private var favoriteButton: some View {
        
        func toggleRequest(item: GuideDetails, token: String) {
            if item.isFavorite {
                guideVM.deleteFromFavorites(id: item.id, token: authVM.response?.accessToken ?? "")
            } else {
                guideVM.addToFavorites(id: item.id, token: authVM.response?.accessToken ?? "")
            }
            guideVM.shouldUpdateFavorites = true
        }
        
        func handleFavorite() {
            isToggled.toggle()
            toggleRequest(item: item, token: authVM.response?.accessToken ?? "")
        }
                
        return Button(action: {
            handleFavorite()
        }) {
            Image(systemName:  isToggled ? "heart.fill" : "heart")
                .foregroundColor(isToggled ? Color.red : Color.gray)
                .font(.system(size: 28))
        }
    }
    
    private var cardTitleView: some View {
        Text(item.title)
            .font(.system(size: 20))
    }
    
    private var cardDescriptionView: some View {
        Text(item.description)
            .font(.system(size: 16))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var showStepsButton: some View {
        NavigationLink(destination: GuideStepsPager(steps: guideVM.guideSteps, guide: item),
                       isActive: $isPresented) {
            Button(action: {
                self.isPresented = true
            }) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue)
                    .frame(width: 55, height: 55)
                    .overlay(
                        Image(systemName: "arrow.right")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    )
            }
        }
    }
}


struct GuideDetailsStyle_Previews: PreviewProvider {
    static var testItem: GuideDetails = GuideDetails(
        id: "1",
        emoji: "🎧",
        title: "Music relaxing",
        description: "It can lots of things, including ralaxing you",
        image: "https://helios-i.mashable.com/imagery/reviews/03iQMbCEXWmZp7RWtWGRrg5/hero-image.fill.size_1248x702.v1623391765.jpg",
        authorId: "fd87aew8ya79d8f1",
        author: Author(username: "yegormi"),
        isFavorite: true
    )
    
    static var previews: some View {
        GuideDetailsStyle(item: testItem)
            .environmentObject(GuideViewModel())
            .environmentObject(AuthViewModel())
            .environmentObject(FavoritesViewModel())
            .previewLayout(.sizeThatFits)
    }
}
