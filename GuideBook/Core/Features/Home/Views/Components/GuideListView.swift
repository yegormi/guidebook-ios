//
//  GuideListViewView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 31.10.2023.
//

import SwiftUI

struct GuideListView: View {
    let guides: [Guide]
    let guideDetails: GuideDetails
    let steps: [GuideStep]
    let title: String
    let onAppear: (Guide) -> Void
    @Binding var isFavorite: Bool
    
    var body: some View {
        List(guides) { guide in
            NavigationLink(destination: GuideDetailsView(details: guideDetails)) {
                GuideVIew(item: guide)
            }
            .onAppear {
                onAppear(guide)
            }
        }
        .listStyle(.insetGrouped)
        .navigationBarTitle(title)
    }
}

struct GuideListView_Previews: PreviewProvider {
    static var guides: [Guide] = [
        Guide(id: "1", title: "Guide 1", description: "Description 1", emoji: "😊"),
        Guide(id: "2", title: "Guide 2", description: "Description 2", emoji: "📖"),
        Guide(id: "3", title: "Guide 3", description: "Description 3", emoji: "🔍")
    ]
    
    static var details: GuideDetails = GuideDetails(
        id: "352345",
        emoji: "😊",
        title: "Guide",
        description: "Description",
        image: "https://cdn-icons-png.flaticon.com/512/1705/1705351.png",
        authorId: "author",
        author: Author(username: "User"),
        isFavorite: true
    )
    
    static var previews: some View {
        GuideListView(
            guides: guides,
            guideDetails: details,
            steps: [GuideStep(id: "1", title: "Step 1", description: "Example of using step 1", image: "https://images.unsplash.com/photo-1575936123452-b67c3203c357?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D", order: 1, guideId: "12412e")],
            title: "Example",
            onAppear: { guide in
                print("Navigated to Guide with ID: \(guide.id)")
            }, isFavorite: .constant(true)
        )
    }
}
