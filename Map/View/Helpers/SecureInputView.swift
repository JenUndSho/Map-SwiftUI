//
//  SecureInputView.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 26.06.2024.
//

import SwiftUI

enum FieldToFocus {
    case secureField
    case textField
}

struct SecureInputView: View {

    @Binding private var text: String
    @State private var isSecured: Bool = true
    @FocusState var isFieldFocus: FieldToFocus?
    private var title: String

    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isSecured {
                    SecureField(title, text: $text)
                        .focused($isFieldFocus, equals: .secureField)
                } else {
                    TextField(title, text: $text)
                        .focused($isFieldFocus, equals: .textField)
                }
            }

            Button(action: {
                withAnimation {
                    isSecured.toggle()
                }
            }) {
                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    .accentColor(.gray)
            }
        }
        .onChange(of: isSecured) { result in
            isFieldFocus = isSecured ? .secureField : .textField
        }
    }
}

#Preview {
    SecureInputView("Text", text: .constant("Text"))
}
