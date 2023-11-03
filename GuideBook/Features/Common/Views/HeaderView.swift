//
//  HeaderView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 03.11.2023.
//

import SwiftUI

struct HeaderView: View {
    let hasNotch: Bool = UIDevice.current.hasNotch
    
    var body: some View {
        HStack {
            headerSection
                .padding(.leading, 20)
                .padding(.top, hasNotch ? 0 : 10)
            Spacer()
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
            .previewLayout(.sizeThatFits)
    }
}

extension HeaderView {
    private var headerSection: some View {
        Text("📘 GuideBook")
            .font(.system(size: 20))
            .bold()
    }
}
