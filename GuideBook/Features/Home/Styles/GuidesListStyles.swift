//
//  GuidesListStyles.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 31.10.2023.
//

import SwiftUI

struct GuidesListStyles: View {
    let guides: [Guide]
    let guideDetails: GuideDetails
    let title: String
    let onAppear: (Guide) -> Void

    var body: some View {
        List(guides) { guide in
            NavigationLink(destination: GuideDetailsStyle(item: guideDetails)) {
                GuideStyle(item: guide)
            }
            .onAppear {
                onAppear(guide)
            }
        }
        .listStyle(.insetGrouped)
        .navigationBarTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct GuidesListStyles_Previews: PreviewProvider {
    static var guides: [Guide] = [
        Guide(id: "1", title: "Guide 1", description: "Description 1", emoji: "😊"),
        Guide(id: "2", title: "Guide 2", description: "Description 2", emoji: "📖"),
        Guide(id: "3", title: "Guide 3", description: "Description 3", emoji: "🔍"),
    ]

    static var details: GuideDetails = .init(
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
        GuidesListStyles(
            guides: guides,
            guideDetails: details,
            title: "Example",
            onAppear: { guide in
                print("Navigated to Guide with ID: \(guide.id)")
            }
        )
    }
}
