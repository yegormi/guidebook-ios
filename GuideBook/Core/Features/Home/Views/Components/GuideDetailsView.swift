//
//  GuideDetailsView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 25.10.2023.
//

import SwiftUI

struct GuideDetailsView: View {
    let details: GuideDetails
 
    @State var isFavorite: Bool = false
    @State var isStepsButtonTapped: Bool = false
    let steps: [GuideStep] = []

    
    var body: some View {
        ScrollView {
            VStack {
                ImageCard(imageURL: details.image)
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
            if !steps.isEmpty {
                showStepsButton
                    .padding(.bottom, 15)
                    .padding(.trailing, 15)
            }
        }
    }
}

extension GuideDetailsView {
    
    private var profilePicture: some View {
        Image(systemName: "person.circle.fill")
            .font(.system(size: 20))
            .foregroundColor(.gray)
    }
    
    private var authorName: some View {
        Text(details.author.username)
            .font(.system(size: 16))
    }
    
    private var favoriteButton: some View {
        Button(action: {
            isFavorite.toggle()
        }) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(isFavorite ? Color.red : Color.gray)
                .font(.system(size: 28))
        }
    }
    
    private var cardTitleView: some View {
        Text(details.title)
            .font(.system(size: 20))
    }
    
    private var cardDescriptionView: some View {
        Text(details.description)
            .font(.system(size: 16))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var showStepsButton: some View {
        NavigationLink(destination: GuideStepsPager(steps: steps, guide: details),
                       isActive: $isStepsButtonTapped) {
            Button(action: {
                self.isStepsButtonTapped = true
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


struct GuideDetailsView_Previews: PreviewProvider {
    
    static var testDetails: GuideDetails = GuideDetails(
        id: "1",
        emoji: "🎧",
        title: "Music relaxing",
        description: "It can lots of things, including ralaxing you",
        image: "https://helios-i.mashable.com/imagery/reviews/03iQMbCEXWmZp7RWtWGRrg5/hero-image.fill.size_1248x702.v1623391765.jpg",
        authorId: "fd87aew8ya79d8f1",
        author: Author(username: "yegormi"),
        isFavorite: true
    )
    
    static var testSteps: [GuideStep] = [
            GuideStep(id: "1", title: "Step 1", description: "Description for step 1", image: "https://www.markitgraphics.co.nz/cdn/shop/products/1_7b9f2e1a-ebec-4911-81db-3ffb3f4edfc4_1024x1024.jpg?v=1469312304", order: 1, guideId: "1"),
            GuideStep(id: "2", title: "Step 2", description: "Description for step 2", image: "https://pngimg.com/uploads/number2/Number%202%20PNG%20images%20free%20download_PNG14925.png", order: 2, guideId: "1"),
            GuideStep(id: "3", title: "Step 3", description: "Description for step 3", image: "https://cdn-icons-png.flaticon.com/512/3841/3841715.png", order: 3, guideId: "1")
        ]
    
    static var previews: some View {
        GuideDetailsView(details: testDetails)
            .previewLayout(.sizeThatFits)
    }
}
