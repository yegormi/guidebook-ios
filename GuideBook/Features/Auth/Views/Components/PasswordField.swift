//
//  PasswordField.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 05.11.2023.
//

import SwiftUI

struct PasswordField: View {
    private let label: String
    @Binding var input: String
    
    init(label: String, input: Binding<String>) {
        self.label = label
        self._input = input
    }
    
    @State private var showText: Bool = false
    @FocusState private var focus: Focus?
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        HStack {
            ZStack {
                SecureField(label, text: $input)
                    .focused($focus, equals: .secure)
                    .opacity(showText ? 0 : 1)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                TextField(label, text: $input)
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
