//
//  Header.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 06.11.2023.
//

import SwiftUI

struct Header: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.system(size: 20))
            .bold()
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header("📘 GuideBook")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
