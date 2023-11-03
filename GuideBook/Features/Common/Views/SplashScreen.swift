//
//  SplashScreen.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 27.10.2023.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {        
        Text("📘 GuideBook")
            .font(.system(size: 40))
            .bold()
            .transition(.offset(y: -(Helpers.screen.height*0.8))
                .combined(with: .scale(scale: 0.5))
                .combined(with: .opacity)
            )
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
            .previewLayout(.sizeThatFits)
    }
}
