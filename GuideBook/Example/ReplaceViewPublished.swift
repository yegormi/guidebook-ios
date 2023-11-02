//
//  ReplaceViewVM.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 29.10.2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var replaceVM: ReplaceViewModel

    var body: some View {
        Group {
            if replaceVM.signInSuccess {
                AppHome()
            }
            else {
                LoginFormView()
            }
        }
    }
}

struct LoginFormView : View {
    @EnvironmentObject var replaceVM: ReplaceViewModel
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showError = false
    
    var body: some View {
        VStack {
            Text("ViewModel")
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
                    replaceVM.signInSuccess = true
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

struct AppHome: View {
    @EnvironmentObject var replaceVM: ReplaceViewModel
    
    var body: some View {
        VStack {
            Text("Hello freaky world!")
            Text("You are signed in.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ReplaceViewModel())
    }
}
