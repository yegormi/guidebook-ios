//
//  InputField.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 05.11.2023.
//

import SwiftUI

struct InputField: View {
    let placeholder: String
    @Binding var text: String
    let type: KeyboardType
    let isInvalid: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color("FieldColor"))
            .frame(maxWidth: .infinity, maxHeight: 50)
            .shadow(radius: 1)
            .overlay {
                if type == .password || type == .confirmPassword {
                    PasswordField(placeholder: placeholder, text: $text)
                        .inputFieldStyle(type: type)
                        .invalidBorder(isActive: isInvalid)
                } else {
                    TextField(placeholder, text: $text)
                        .inputFieldStyle(type: type)
                        .invalidBorder(isActive: isInvalid)
                }
            }
            .padding(.top, 10)
    }
}
