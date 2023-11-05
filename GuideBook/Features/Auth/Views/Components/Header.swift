//
//  Header.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 06.11.2023.
//

import SwiftUI

struct Header: View {
    var body: some View {
        Text("📘 GuideBook")
            .font(.system(size: 20))
            .bold()
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
