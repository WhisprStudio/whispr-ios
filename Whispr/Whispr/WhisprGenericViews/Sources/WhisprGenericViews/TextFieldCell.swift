//
//  TextFieldCell.swift
//  
//
//  Created by Paul Erny on 04/10/2021.
//

import SwiftUI

public struct TextFieldCell: View {
    @Binding var text: String
    var label: String
    var placeholder: String
    var onEditingChange: (String)->()

    @Environment(\.primaryColor) var primaryColor : Color
    @Environment(\.secondaryColor) var secondaryColor : Color
    @Environment(\.textInputColor) var textInputColor : Color

    public init(text: Binding<String>,
                label: String = "",
                placeholder: String = "Your text...",
                onEditingChange: @escaping (String)->() = {_ in}) {
        self._text = text
        self.label = label
        self.placeholder = placeholder
        self.onEditingChange = onEditingChange
    }

    public var body: some View {
        if label.isEmpty {
            ColorizableTextField(textInputColor: textInputColor, secondaryColor: secondaryColor, text: $text, placeholder: placeholder, inputAlignment: .leading, placeholderAlignment: .leading, onEditingChange: onEditingChange)
        } else {
            HStack {
                if primaryColor != .primary {
                    Text(label)
                        .foregroundColor(primaryColor)
                        .primaryFont(size: .L, weight: .medium)
                } else {
                    Text(label)
                        .primaryFont(size: .L, weight: .medium)
                }
                ColorizableTextField(textInputColor: textInputColor, secondaryColor: secondaryColor, text: $text, placeholder: placeholder, inputAlignment: .trailing, placeholderAlignment: .trailing, onEditingChange: onEditingChange)
            }
        }
    }
}

struct ColorizableTextField: View {
    var textInputColor : Color
    var secondaryColor : Color
    @Binding var text: String
    var placeholder: String
    var inputAlignment: TextAlignment
    var placeholderAlignment: Alignment
    var onEditingChange: (String)->()
    
    var body: some View {
        if secondaryColor != .secondary {
            if textInputColor != .primary {
                TextField("", text: $text)
                    .onChange(of: text) {
                        self.onEditingChange($0)
                    }
                    .multilineTextAlignment(inputAlignment)
                    .placeholder(when: text.isEmpty, alignment: placeholderAlignment) {
                        Text(placeholder)
                            .foregroundColor(secondaryColor)
                            .primaryFont(size: .L, weight: .medium)
                    }
                    .foregroundColor(textInputColor)
                    .primaryFont(size: .L, weight: .medium)
            } else {
                TextField("", text: $text)
                    .onChange(of: text) {
                        self.onEditingChange($0)
                    }
                    .multilineTextAlignment(inputAlignment)
                    .placeholder(when: text.isEmpty, alignment: placeholderAlignment) {
                        Text(placeholder)
                            .foregroundColor(secondaryColor)
                            .primaryFont(size: .L, weight: .medium)
                    }
                    .primaryFont(size: .L, weight: .medium)
            }
        } else {
            if textInputColor != .primary {
                TextField(placeholder, text: $text)
                    .onChange(of: text) {
                        self.onEditingChange($0)
                    }
                    .multilineTextAlignment(inputAlignment)
                    .foregroundColor(textInputColor)
                    .primaryFont(size: .L, weight: .medium)
            } else {
                TextField(placeholder, text: $text)
                    .onChange(of: text) {
                        self.onEditingChange($0)
                    }
                    .multilineTextAlignment(inputAlignment)
                    .primaryFont(size: .L, weight: .medium)
            }
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

public struct TextFieldCellContainer: View {
    @State var text: String = ""
    
    public var body: some View {
        VStack {
            TextFieldCell(text: $text, label: "Your text")
                .secondaryColor(.blue)
                .textInputColor(.red)
            Text(text)
        }
    }
}

struct TextFieldCell_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldCellContainer()
            .preferredColorScheme(.dark)
    }
}
