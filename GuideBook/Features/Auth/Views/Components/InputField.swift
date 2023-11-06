//
//  InputField.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 05.11.2023.
//

import SwiftUI

struct InputField: View {
    let label: String
    @Binding var text: String
    let type: KeyboardType
    let isInvalid: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color("FieldColor"))
            .frame(height: 50)
            .shadow(radius: 1)
            .overlay {
                if type == .password {
                    PasswordField(label: label, input: $text)
                        .inputFieldStyle(type: type)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    TextField(label, text: $text)
                        .inputFieldStyle(type: type)
                        .textFieldStyle(.plain)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .invalidBorder(isActive: isInvalid)
    }
}

struct InputField_Previews: PreviewProvider {
    @State static var text = ""
    
    static var previews: some View {
        InputField(
            label: "Username",
            text: $text,
            type: .username,
            isInvalid: false
        )
        .previewLayout(.sizeThatFits)
        .padding(30)
    }
}
