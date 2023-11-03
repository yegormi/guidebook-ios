//
//  ParentView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 27.10.2023.
//

import SwiftUI

struct ParentView: View {
    @EnvironmentObject var guideVM: GuideViewModel
    @EnvironmentObject var authVM: AuthViewModel
    
    @State private var willShowNextScreen: Bool = false
    
    var body: some View {
        ZStack {
            if willShowNextScreen || authVM.shouldLogOut {
                if (authVM.response == nil) {
                    AuthView()
                } else {
                    TabScreen()
                }
            } else {
                SplashScreen()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut) {
                    willShowNextScreen = true
                }
            }
        }
        .alert(authVM.sessionExpiredAlert.title,
               isPresented: $authVM.isSessionExpiredAlertPresented) {
            Button("OK", role: .cancel) {
                authVM.signOut()
            }
        } message: {
            Text(authVM.sessionExpiredAlert.description)
        }
    }
}

struct ParentView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView()
            .environmentObject(GuideViewModel())
            .environmentObject(AuthViewModel())
    }
}
