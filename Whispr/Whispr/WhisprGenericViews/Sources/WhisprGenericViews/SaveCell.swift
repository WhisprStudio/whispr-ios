//
//  SaveCell.swift
//  
//
//  Created by Paul Erny on 09/10/2021.
//

import SwiftUI

/// A control that initiates an action.
///
/// A premade customization of the ``ButtonCell`` specifically dedicated to validating an action.
/// The label is preset to "Save" and its color is set to iOS's default blue by default.
///
/// Therefore it only takes a method or closure property as parameter. For example:
///
/// ```swift
///    SaveCell(action: saveContent)
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
public struct SaveCell: View {
    private var action: (() -> ())
    
    @Environment(\.saveTextColor) var saveTextColor : Color
    
    /// Default initializer
    ///
    /// Parameter:
    ///  - action: method or closure property that does something when a user clicks or taps the button
    ///
    /// ### Usage
    ///
    /// ```swift
    ///    SaveCell(action: saveContent)
    /// ```
    public init(action: @escaping (() -> ())) {
        self.action = action
    }
    
    public var body: some View {
        if saveTextColor != .primary {
            ButtonCell(label: "Enregister", action: action)
                .padding(.leading)
                .primaryColor(saveTextColor)
        } else {
            ButtonCell(label: "Enregister", action: action)
                .padding(.leading)
                .primaryColor(.blue)
        }
    }
}

struct SaveCell_Previews: PreviewProvider {
    static var previews: some View {
        SaveCell(action: {})
            .preferredColorScheme(.dark)
    }
}
