//
//  DeleteCell.swift
//  
//
//  Created by Paul Erny on 09/10/2021.
//

import SwiftUI

/// A control that initiates an action.
///
/// A premade customization of the ``ButtonCell`` specifically dedicated to deleting content.
/// The label is preset to "Delete" and its color is set to iOS's default red by default.
///
/// Therefore it only takes a method or closure property as parameter. For
/// example:
///
/// ```swift
///    DeleteCell(action: deleteContent)
/// ```
///
/// ### Styling DeleteCell

/// ```swift
///    DeleteCell(action: deleteContent)
///        .deleteTextColor(myRedColor)
/// ```
/// #### primaryColor
///
/// ```swift
///     func deleteTextColor(_ color: Color) -> some View
/// ```
/// When applied, replaces the color of the cell's text by the one given as parameter
public struct DeleteCell: View {
    private var action: (() -> ())
    
    @Environment(\.deleteTextColor) var deleteTextColor : Color
    
    /// Default initializer
    ///
    /// Parameter:
    ///  - action: method or closure property that does something when a user clicks or taps the button
    ///
    /// ### Usage
    ///
    /// ```swift
    ///    DeleteCell(action: deleteContent)
    /// ```
    public init(action: @escaping (() -> ())) {
        self.action = action
    }
    
    public var body: some View {
        if deleteTextColor != .primary {
            ButtonCell(label: "Supprimer", action: action)
                .padding(.leading)
                .primaryColor(deleteTextColor)
        } else {
            ButtonCell(label: "Supprimer", action: action)
                .padding(.leading)
                .primaryColor(.red)
        }
    }
}

struct DeleteCell_Previews: PreviewProvider {
    static var previews: some View {
        DeleteCell(action: {})
            .preferredColorScheme(.dark)
    }
}
