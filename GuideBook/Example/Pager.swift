//
//  Pager.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 01.11.2023.
//

import SwiftUI

struct Pager: View {
    
    // MARK: - Private Properties
    
    @State private var currentIndex = 0
    private let colors: [Color] = [.red, .blue, .green, .yellow, .indigo, .mint, .pink]
    
    // MARK: - Body
    
    var body: some View {
        TabView(selection: $currentIndex.animation()) { // 1
            ForEach(0..<colors.count, id: \.self) { index in
                colors[index]
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .automatic))
        .overlay(
            VStack(spacing: 20) {
                SquircleIndexView(numberOfPages: Double(colors.count), currentIndex: Double(currentIndex))
                Fancy3DotsIndexView(numberOfPages: colors.count, currentIndex: currentIndex)
                SimpleCount(numberOfPages: colors.count, currentIndex: currentIndex)
            }
        )
    }
}

#Preview {
    Pager()
}
