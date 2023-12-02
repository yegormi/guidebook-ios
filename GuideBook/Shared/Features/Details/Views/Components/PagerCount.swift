//
//  PagerCount.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 30.11.2023.
//

import SwiftUI

struct PagerCount: View {
  
  // MARK: - Public Properties
  
  let numberOfPages: Int
  let currentIndex: Int
  
  // MARK: - Body
  
  var body: some View {
      Text("\(currentIndex + 1) / \(numberOfPages)")
          .font(.system(size: 20))
          .foregroundStyle(Color.primary)
  }
}

struct PagerCount_Previews: PreviewProvider {
    static var previews: some View {
        PagerCount(numberOfPages: 5, currentIndex: 2)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
