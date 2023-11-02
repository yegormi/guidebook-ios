//
//  PasswordField.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 31.10.2023.
//

import SwiftUI

struct PasswordField: View {
    
    let placeholder: LocalizedStringKey
    
    @Binding
    var text: String
    
    @State
    private var showText: Bool = false
    
    private enum Focus {
        case secure, text
    }
    
    @FocusState
    private var focus: Focus?
    
    @Environment(\.scenePhase)
    private var scenePhase
    
    var body: some View {
        HStack {
            ZStack {
                SecureField(placeholder, text: $text)
                    .focused($focus, equals: .secure)
                    .opacity(showText ? 0 : 1)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                TextField(placeholder, text: $text)
                    .focused($focus, equals: .text)
                    .opacity(showText ? 1 : 0)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            
            Button(action: {
                showText.toggle()
            }) {
                Image(systemName: showText ? "eye.slash.fill" : "eye.fill")
            }
            .accentColor(.secondary)
        }
        .onChange(of: focus) { newValue in
            // if the PasswordField is focused externally, then make sure the correct field is actually focused
            if newValue != nil {
                focus = showText ? .text : .secure
            }
        }
        .onChange(of: scenePhase) { newValue in
            if newValue != .active {
                showText = false
            }
        }
        .onChange(of: showText) { newValue in
            if focus != nil { // Prevents stealing focus to this field if another field is focused, or nothing is focused
                DispatchQueue.main.async { // Needed for general iOS 16 bug with focus
                    focus = newValue ? .text : .secure
                }
            }
        }
    }
}
