//
//  GuideStepsVIew.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 01.11.2023.
//

import SwiftUI

struct GuideStepsVIew: View {
    let step:  GuideStep
    let guide: GuideDetails
    
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
        Text("\(guide.emoji) \(guide.title)")
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


struct GuideStepsVIew_Previews: PreviewProvider {
    static var previews: some View {
        let sampleStep = GuideStep(id: "1", title: "Step 1", description: "Description for Step 1", image: "https://www.naveedulhaq.com/wp-content/uploads/2023/04/image.png", order: 1, guideId: "guide1")
        let sampleGuide = GuideDetails(
            id: "1",
            emoji: "📚",
            title: "Sample Guide",
            description: "This is a sample guide description. It can contain information about the guide's content.",
            image: "https://www.naveedulhaq.com/wp-content/uploads/2023/04/image.png",
            authorId: "author1",
            author: Author(username: "JohnDoe"),
            isFavorite: false
        )
        
        return GuideStepsVIew(step: sampleStep, guide: sampleGuide)
            .previewLayout(.sizeThatFits)
    }
}
