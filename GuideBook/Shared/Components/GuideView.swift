//
//  GuideView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 27.11.2023.
//
//

import SwiftUI

struct GuideView: View {
    let item: Guide
    
    var body: some View {
        HStack(spacing: 0) {
            Text(item.emoji)
                .font(.system(size: 30))
                .padding([.top,.bottom,.trailing], 10)
            VStack(alignment: .leading) {
                Text(item.title)
                    .lineLimit(1)
                    .font(.system(size: 18))
                    .foregroundColor(.primary)
                Text(item.description)
                    .lineLimit(1)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.forward")
                .font(.system(size: 13, weight: .semibold))
                .frame(width: 15, height: 15)
                .foregroundStyle(Color.primary.opacity(0.4))
        }
    }
}


struct GuideView_Previews: PreviewProvider {
    static var testItem: Guide = Guide(
        id: "bs9d8f908s7dv9usdf",
        title: "Guide to Python Data Science",
        description: "Dive into data science with Python",
        emoji: "🐍"
    )
    
    static var previews: some View {
        GuideView(item: testItem)
            .previewLayout(.sizeThatFits)
    }
}
