//
//  InputField.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 05.11.2023.
//

import SwiftUI

struct InputField: View {
    private let label: String
    @Binding private var text: String
    private let type: KeyboardType
    private let isInvalid: Bool
    
    init(label: String, text: Binding<String>, type: KeyboardType, isInvalid: Bool) {
        self.label = label
        self._text = text
        self.type = type
        self.isInvalid = isInvalid
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color("FieldColor"))
            .frame(maxWidth: .infinity, maxHeight: 50)
            .shadow(radius: 1)
            .overlay {
                if type == .password {
                    PasswordField(label: label, input: $text)
                        .inputFieldStyle(type: type)
                } else {
                    TextField(label, text: $text)
                        .inputFieldStyle(type: type)
                }
            }
            .invalidBorder(isActive: isInvalid)
    }
}
