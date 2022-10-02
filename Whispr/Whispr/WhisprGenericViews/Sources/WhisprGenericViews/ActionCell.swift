//
//  ActionCell.swift
//  
//
//  Created by Paul Erny on 02/10/2022.
//

import SwiftUI

/// A control that initiates an action.
///
/// A premade customization of the ``ButtonCell`` specifically dedicated to trigger a simple action (i.e.: activate, save, delete, ...).
/// The label is set to the one given as parameter and its color is set to iOS's default blue by default.
///
/// ```swift
///    SaveCell(action: saveContent, label: "Activate")
/// ```
///
/// ### Styling DeleteCell
///
/// ```swift
///    SaveCell(action: saveContent)
///        .saveTextColor(.green)
/// ```
/// #### saveTextColor
///
/// ```swift
///     func saveTextColor(_ color: Color) -> some View
/// ```
/// When applied, replaces the color of the cell's text by the one given as parameter
public struct ActionCell: View {
    private var action: (() -> ())
    @Binding var label: String
    
    @Environment(\.saveTextColor) var saveTextColor : Color
    
    /// Default initializer
    ///
    /// Parameter:
    ///  - action: method or closure property that does something when a user clicks or taps the button
    ///  - label: String used as label for the button
    ///
    /// ### Usage
    ///
    /// ```swift
    ///    ActionCell(action: saveContent, label: "Activate")
    /// ```
    public init(action: @escaping (() -> ()), label: Binding<String>) {
        self.action = action
        self._label = label
    }
    
    public var body: some View {
        if saveTextColor != .primary {
            ButtonCell(label: self.label, action: action)
                .padding(.leading)
                .primaryColor(saveTextColor)
        } else {
            ButtonCell(label: self.label, action: action)
                .padding(.leading)
                .primaryColor(.blue)
        }
    }
}

struct ActionCellContainer: View {
    var textOne = "one"
    var textTwo = "two"
    @State var label: String = "one"
    
    public var body: some View {
        ActionCell(action: {
            label = label == textOne ? textTwo : textOne
        }, label: $label)
            .preferredColorScheme(.dark)
    }
}

struct ActionCell_Previews: PreviewProvider {
    static var previews: some View {
        ActionCellContainer()
            .preferredColorScheme(.dark)
    }
}
