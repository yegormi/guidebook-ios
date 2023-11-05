//
//  PasswordField.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 05.11.2023.
//

import SwiftUI

struct PasswordField: View {
    let label: String
    @Binding var input: String
    
    @State private var showText: Bool = false
    @FocusState private var focus: Focus?
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        HStack {
            ZStack {
                SecureField(label, text: $input)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .focused($focus, equals: .secure)
                    .opacity(showText ? 0 : 1)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                TextField(label, text: $input)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .focused($focus, equals: .text)
                    .opacity(showText ? 1 : 0)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            
            Button(action: {
                showText.toggle()
            }) {
                Image(systemName: showText ? "eye.slash.fill" : "eye.fill")
                    .frame(maxWidth: 40, maxHeight: 50)
            }
            .accentColor(.secondary)
        }
        .onChange(of: focus) { newValue in
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
            if focus != nil {
                DispatchQueue.main.async {
                    focus = newValue ? .text : .secure
                }
            }
        }
    }
}

extension PasswordField {
    private enum Focus {
        case secure, text
    }
}

struct PasswordField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordField(
            label: "Password",
            input: .constant("Lorem Ipsum")
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
