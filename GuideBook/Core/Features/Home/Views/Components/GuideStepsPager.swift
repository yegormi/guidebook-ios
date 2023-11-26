import SwiftUI

struct GuideStepsPager: View {
    let steps: [GuideStep]
    let guide: GuideDetails
    
    @State private var currentPage = 0
    
    var body: some View {
        GeometryReader { geometry in
            TabView(selection: $currentPage) {
                ForEach(0..<steps.count, id: \.self) { index in
                    GuideStepsVIew(step: steps[index], guide: guide)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .padding(.bottom, 70)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .indexViewStyle(.page(backgroundDisplayMode: .never))
            .progressViewStyle(.automatic)
            .overlay(alignment: .bottom) {
                HStack {
                    Button(action: {
                        withAnimation {
                            currentPage -= 1
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .padding()
                    }
                    .disabled(currentPage == 0)
                    .padding(.leading)
                    
                    Spacer()
                    
                    PagerCount(numberOfPages: steps.count, currentIndex: currentPage)
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .padding()
                    }
                    .disabled(currentPage == steps.count - 1)
                    .padding(.trailing)
                }
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 20.0)
                        .foregroundStyle(Color("FieldColor"))
                        .shadow(radius: 1)
                }
                .padding([.leading, .trailing, .top], 30)
            }
        }
    }
}

struct GuideStepsPager_Previews: PreviewProvider {
    static var sampleGuide = GuideDetails(
        id: "1",
        emoji: "📚",
        title: "Sample Guide",
        description: "This is a sample guide description. It can contain information about the guide's content.",
        image: "sample_image_url",
        authorId: "author1",
        author: Author(username: "JohnDoe"),
        isFavorite: false
    )
    
    
    static var sampleGuideSteps: [GuideStep] = [
        GuideStep(id: "1", title: "Step 1", description: "Description 1", image: "https://m.media-amazon.com/images/I/61ZIMnPNnxL._AC_UF1000,1000_QL80_.jpg", order: 1, guideId: "guide1"),
        GuideStep(id: "2", title: "Step 2", description: "Description 2", image: "https://www.thespruceeats.com/thmb/LIfWsru7OyxtrscIuH97o8NQCS8=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/instant-pot-beef-stew-5218740-step-01-b5c06001cf9a45dca56f87bb7e299b81.jpg", order: 2, guideId: "guide1"),
        GuideStep(id: "3", title: "Step 3", description: "Description 3", image: "https://m.media-amazon.com/images/I/51ZEuKxGj0L._AC_UF1000,1000_QL80_.jpg", order: 3, guideId: "guide1")
    ]
    
    static var previews: some View {
        GuideStepsPager(steps: sampleGuideSteps, guide: sampleGuide)
            .previewLayout(.sizeThatFits)
    }
}
