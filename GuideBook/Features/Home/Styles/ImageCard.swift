//
//  ImageCard.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 02.11.2023.
//

import SwiftUI

struct ImageCard: View {
    let imageURL: String

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.black.opacity(0.4))
            .frame(maxWidth: .infinity)
            .aspectRatio(1.0, contentMode: .fit)
            .background(
                AsyncImage(url: URL(string: imageURL)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .aspectRatio(contentMode: .fill)
                            .blur(radius: 10)
                    }
                }
            )
            .overlay(
                AsyncImage(url: URL(string: imageURL)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .aspectRatio(contentMode: .fit)
                            .shadow(radius: 10)
                    } else {
                        ProgressView()
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 10)
        
    }
}

struct ImageCard_Previews: PreviewProvider {
    static let url: String = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE4LLFK?ver=29db&q=90&m=6&h=705&w=1253&b=%23FFFFFFFF&f=jpg&o=f&p=140&aim=true"
    
    static var previews: some View {
        ImageCard(imageURL: url)
            .previewLayout(.sizeThatFits)
            .padding(30)
    }
}


