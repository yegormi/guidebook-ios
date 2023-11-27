//
//  ProfileCard.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//

import SwiftUI
import SkeletonUI

struct ProfileCardStyle: View {
    let user: UserInfo?
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 50))
                .frame(width: 50, height: 50)
                .padding(5)
                .skeleton(with: user == nil,
                          size: CGSize(width: 50, height: 50), 
                          shape: .circle)
            
            VStack(alignment: .leading) {
                Text(user?.username)
                    .lineLimit(1)
                    .font(.system(size: 20))
                    .foregroundColor(.primary)
                    .skeleton(with: user == nil,
                              shape: .rectangle)
                
                Text(user?.email)
                    .lineLimit(1)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .skeleton(with: user == nil,
                              shape: .rectangle)
            }
        }
        .frame(height: 60)
    }
}



struct ProfileCardStyle_Previews: PreviewProvider {
    static var testItem: UserInfo = UserInfo(
        id: "1",
        username: "yegormi",
        email: "egormiropoltsev79@gmail.com"
    )
    
    static var previews: some View {
        ProfileCardStyle(user: testItem)
            .previewLayout(.sizeThatFits)
    }
}
