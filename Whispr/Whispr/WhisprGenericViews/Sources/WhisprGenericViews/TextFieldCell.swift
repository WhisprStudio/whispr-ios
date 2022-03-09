//
//  TextFieldCell.swift
//  
//
//  Created by Paul Erny on 04/10/2021.
//

import SwiftUI

/// A control that displays an editable text interface.
///
/// You create a TextFieldCell by providing an action, label, optionnal placeholder text and a String binding.
/// The action is either a method or closure property that does something when a user inputs text in the field.
/// The label and placeholder are strings that describe the field's action and default content --- for
/// example, by showing only a label:
///
/// ```swift
///     TextFieldCell(text: $userInput, label: "Username: ")
/// ```
/// ### Styling TextFieldCell
///
/// ```swift
///     TextFieldCell(text: $userInput, label: "Username: ")
///          .primaryColor(.green)
///          .secondaryColor(.yellow)
///          .textInputColor(.red)
/// ```
/// #### primaryColor
///
/// ```swift
///     func primaryColor(_ color: Color) -> some View
/// ```
/// When applied, replaces the text label's color with the given parameter
///
/// #### secondaryColor
///
/// ```swift
///     func secondaryColor(_ color: Color) -> some View
/// ```
/// When applied, replaces the placeholder text's color with the given parameter
///
/// #### textInputColor
///
/// ```swift
///     func textInputColor(_ color: Color) -> some View
/// ```
/// When applied, replaces the user input text's color with the given parameter
public struct TextFieldCell: View {
    @Binding var text: String
    var label: String
    var placeholder: String
    var onEditingChange: (String)->()

    @Environment(\.primaryColor) var primaryColor : Color
    @Environment(\.secondaryColor) var secondaryColor : Color
    @Environment(\.textInputColor) var textInputColor : Color

    /// Default initializer
    ///
    /// Parameter:
    ///  - label: A String or LocalizedStringKey representing the text displayed left of the input
    ///  - text: Binding to a String holding the input value
    ///  - placeholder: A String or LocalizedStringKey representing default text of the input field
    ///  - action: method or closure property that does something when a user inputs text
    ///
    /// ### Usage
    ///
    /// ```swift
    ///     TextFieldCell(text: $userInput, label: "Username: ")
    ///     TextFieldCell(text: $userInput,
    ///                   label: "Username: ",
    ///                   placeholder: "Your username",
    ///                   onEditingChange: saveUsername)
    /// ```
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

struct TextFieldCellContainer: View {
    @State var text: String = ""
    
    public var body: some View {
        VStack {
            TextFieldCell(text: $text, label: "Your text")
                .primaryColor(.green)
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
