//
//  SquircleIndexView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 02.11.2023.
//

import SwiftUI

struct SquircleIndexView: View {
  
  // MARK: - Public Properties
  
  let numberOfPages: Double
  let currentIndex: Double
  
  
  // MARK: - Drawing Constants
  
  private let lineWidth: CGFloat = 4.0
  private let cornerRadius: CGFloat = 15.0
  private let length: CGFloat = 48.0
  private let foregroundColor = Color.white
  
  // increase currentIndex to compensate for arrays that start with index 0
  private var startTrim: CGFloat {
    CGFloat((1 / numberOfPages) * currentIndex)
  }
  
  private var endTrim: CGFloat {
    CGFloat((1 / numberOfPages) * (currentIndex + 1))
  }
  
  
  // MARK: - Body
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        .trim(from: startTrim, to: endTrim)
        .stroke(foregroundColor, lineWidth: lineWidth)
      
      
      RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        .stroke(foregroundColor.opacity(0.3), lineWidth: lineWidth)
    }
    .frame(width: length, height: length)
  }
}
