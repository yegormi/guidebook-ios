//
//  SquircleIndexView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 02.11.2023.
//

import SwiftUI

struct SimpleCount: View {
  
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

struct SimpleCount_Previews: PreviewProvider {
    static var previews: some View {
        SimpleCount(numberOfPages: 5, currentIndex: 2)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
