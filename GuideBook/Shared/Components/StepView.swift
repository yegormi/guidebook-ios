//
//  StepView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 30.11.2023.
//

import SwiftUI

struct StepView: View {
    let step:  GuideStep
    let details: GuideDetails
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ImageCard(imageURL: step.image)
                    .padding(.bottom, 25)
                guideTitle
                    .padding(.bottom, 5)
                stepTitle
                    .padding(.bottom, 10)
                Divider()
                stepDescription
                    .padding(.top, 10)
            }
            .navigationBarTitle("Steps")
            .padding(30)
        }
    }
    
    private var guideTitle: some View {
        Text("\(details.emoji) \(details.title)")
            .font(.system(size: 16))
    }
    
    private var stepTitle: some View {
        Text(step.title)
            .font(.system(size: 20, weight: .semibold))
    }
    private var stepDescription: some View {
        Text(step.description)
            .font(.system(size: 15))
    }
}


struct StepView_Previews: PreviewProvider {
    static let sampleStep = GuideStep(id: "1", title: "Step 1", description: "Description for Step 1", image: "https://www.naveedulhaq.com/wp-content/uploads/2023/04/image.png", order: 1, guideId: "guide1")
    static let sampleGuide = GuideDetails(
        id: "1",
        emoji: "📚",
        title: "Sample Guide",
        description: "This is a sample guide description. It can contain information about the guide's content.",
        image: "https://www.naveedulhaq.com/wp-content/uploads/2023/04/image.png",
        authorId: "author1",
        author: Author(username: "JohnDoe"),
        isFavorite: false
    )
    static var previews: some View {
        StepView(step: sampleStep, details: sampleGuide)
            .previewLayout(.sizeThatFits)
    }
}
