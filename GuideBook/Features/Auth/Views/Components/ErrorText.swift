//
//  ErrorText.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 07.11.2023.
//

import SwiftUI

struct ErrorText: View {
    let message: String
    
    var body: some View {
        HStack {
            Text(message)
                .foregroundColor(.red)
                .font(.system(size: 16))
            Spacer()
        }
    }
}
