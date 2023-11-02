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
    
    @State private var isToggled:       Bool = false
    @State private var isPresented:       Bool = false
    
    
    var body: some View {
        if isPresented {
            GuideStepsPager(steps: guideVM.guideSteps, guide: item)
                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)).animation(.linear))
        } else {
            ScrollView {
                VStack {
                    ImageCard(imageURL: item.image)
                        .padding(.bottom, 25)
                    HStack {
                        VStack {
                            HStack() {
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
                }
                .navigationBarTitle("Details")
                .padding(30)
            }
            .onAppear {
                isToggled = guideVM.isFavorite
            }
            .onChange(of: isToggled) { newState in
                guideVM.setFavorite(to: newState, details: item)
            }
            .safeAreaInset(edge: .bottom, alignment: .trailing) {
                if !guideVM.guideSteps.isEmpty {
                    showStepsButton
                        .padding(.bottom, 15)
                        .padding(.trailing, 15)
                }
            }
        }
    }
}

extension GuideDetailsStyle {
    
    private var profilePicture: some View {
        Image(systemName: "person.circle.fill")
            .font(.system(size: 24))
            .foregroundColor(.gray)
    }
    
    private var authorName: some View {
        Text(item.author.username)
            .font(.system(size: 16))
    }
    
    func handleFavoriteToggle() {
        isToggled.toggle()
        if let token = authVM.response?.accessToken {
            if isToggled {
                guideVM.addToFavorites(id: item.id, token: token)
            } else {
                guideVM.deleteFromFavorites(id: item.id, token: token)
            }
            guideVM.shouldUpdateFavorites = true
        }
    }
    
    private var favoriteButton: some View {
        Button(action: handleFavoriteToggle) {
            Image(systemName: isToggled ? "heart.fill" : "heart")
                .foregroundColor(isToggled ? .red : .gray)
                .font(.system(size: 24))
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
            .padding(.top, 10)
    }
    
    private var showStepsButton: some View {
        Button(action: {
            withAnimation {
                isPresented.toggle()
            }
        }) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue)
                .frame(width: 55, height: 55)
                .overlay(
                    Image(systemName: "arrow.up")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                )
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
