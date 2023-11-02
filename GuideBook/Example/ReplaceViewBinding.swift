//
//  ReplaceView.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 29.10.2023.
//

import SwiftUI

struct ChooseView: View {
    @State private var isSignedIn: Bool = false

    var body: some View {
        return Group {
            if isSignedIn {
                Home()
            }
            else {
                LoginForm(isSignedIn: $isSignedIn)
            }
        }
    }
}

struct LoginForm : View {
    @EnvironmentObject var replaceVM: ReplaceViewModel
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showError = false
    @Binding var isSignedIn: Bool
    
    var body: some View {
        VStack {
            Text("Binding")

            HStack {
                Text("Username")
                TextField("type here", text: $username)
            }.padding()
            
            HStack {
                Text("Password")
                TextField("type here", text: $password)
                    .textContentType(.password)
            }.padding()
            
            Button("Sign In") {
                if(self.username == self.password) {
                    isSignedIn = true
                }
                else {
                    self.showError = true
                }
            }
            
            if showError {
                Text("Incorrect username/password").foregroundColor(Color.red)
            }
        }
    }
}

struct Home: View {
    @EnvironmentObject var replaceVM: ReplaceViewModel
    
    var body: some View {
        VStack {
            Text("Hello freaky world!")
            Text("You are signed in.")
        }
    }
}

struct ChooseView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseView()
    }
}
