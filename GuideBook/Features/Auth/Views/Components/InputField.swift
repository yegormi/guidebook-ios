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
    let errorText: String?

    init(label: String, text: Binding<String>, type: KeyboardType, isInvalid: Bool, errorText: String? = nil) {
        self.label = label
        self._text = text
        self.type = type
        self.isInvalid = isInvalid
        self.errorText = errorText
    }

    var body: some View {
        VStack {
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

            if let errorText = errorText {
                HStack {
                    Text(errorText)
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                    Spacer()
                }
                .padding(.leading, 10)
            }
        }
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
