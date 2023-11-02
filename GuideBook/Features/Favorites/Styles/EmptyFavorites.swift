//
//  EmptyFavorites.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 01.11.2023.
//

import SwiftUI

struct EmptyFavorites: View {
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Text("🔍")
                    .font(.system(size: 70))
                    .padding(5)
                Text("No favorite guides")
                    .font(.system(size: 16, weight: .regular))
                    .padding(.bottom, 5)
            }
            Spacer()
        }
        .padding(10)
    }
}

struct EmptyFavorites_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Form {
                EmptyFavorites()
            }
        }
    }
}


