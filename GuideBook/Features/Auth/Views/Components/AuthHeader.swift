//
//  AuthHeader.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 06.11.2023.
//

import SwiftUI

struct AuthHeader: View {
    var body: some View {
        Text("📘 GuideBook")
            .font(.system(size: 20))
            .bold()
    }
}

struct AuthHeader_Previews: PreviewProvider {
    static var previews: some View {
        AuthHeader()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
