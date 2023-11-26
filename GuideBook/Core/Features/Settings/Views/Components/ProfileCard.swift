//
//  ProfileCard.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//

import SwiftUI

struct ProfileCardStyle: View {
    let card: UserInfo
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 50))
                .padding([.top, .bottom, .trailing], 5)
            VStack(alignment: .leading) {
                Text(card.username)
                    .lineLimit(1)
                    .font(.system(size: 20))
                    .foregroundColor(.primary)
                Text(card.email)
                    .lineLimit(1)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
        }
    }
}


struct ProfileCardStyle_Previews: PreviewProvider {
    static var testItem: UserInfo = UserInfo(id: "1",
                                             username: "yegormi",
                                             email: "egormiropoltsev79@gmail.com"
    )
    
    static var previews: some View {
        ProfileCardStyle(card: testItem)
            .previewLayout(.sizeThatFits)
    }
}
