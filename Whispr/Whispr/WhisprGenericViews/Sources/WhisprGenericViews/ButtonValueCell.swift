//
//  ButtonValueCell.swift
//  
//
//  Created by Paul Erny on 22/10/2021.
//

import SwiftUI

/// A control that initiates an action.
///
/// A derived version of the ``ButtonCell`` where the optionnal View that can be added to the right of
/// the button is replaced by a String or LocalizedStringKey.
/// This is equivalent to passing a Text as the right view to a ButtonCell.
///
/// You create a ButtonValueCell the same way you would a ``ButtonCell``. For
/// example:
///
/// ```swift
///    ButtonValueCell(label: "Wi-Fi",
///                    value: wifi.description,
///                    action: {},
///                    leftView: {
///                        Image(systemName: "wifi.square.fill")
///                            .foregroundColor(.blue)
///                    }
///    )
/// ```
///
/// For the common case of text-only labels, you can use the convenience
/// initializer that takes a label string or LocalizedStringKey as its first
/// parameter:
///
/// ```swift
///     ButtonValueCell(label: "Connected as: ", value: user.name, action: changeUser)
/// ```
///
/// ### Styling ButtonCells

/// ```swift
///     ButtonValueCell(label: "Connected as: ", value: user.name, action: changeUser)
///          .primaryColor(.green)
///          .secondaryColor(.yellow)
///          .clickedColor(.yellow)
/// ```
/// #### primaryColor
///
/// ```swift
///     func primaryColor(_ color: Color) -> some View
/// ```
/// When applied, sets the label's color to the one given as parameter
///
/// #### secondaryColor
///
/// ```swift
///     func secondaryColor(_ color: Color) -> some View
/// ```
/// When applied, sets the sublabel's color (if any) and the value's color to the one given as parameter
///
/// #### clickedColor
///
/// ```swift
///     func clickedColor(_ color: Color) -> some View
/// ```
/// When applied, replaces both primary and seconday colors of the view with the given parameter upon clicking on said button
public struct ButtonValueCell<LeftView: View>: View {
    private var action: (() -> ())
    private let content: LeftView?
    @State private var isClicked: Bool = false
    private let alignment: HorizontalAlignment!
    
    var labelText: Text
    private var valueText: Text?
    private var subLabelText: Text?
    
    @Environment(\.primaryColor) var primaryColor : Color
    @Environment(\.secondaryColor) var secondaryColor : Color
    @Environment(\.clickedColor) var clickedColor : Color

    /// Creates a Button simillar the the default one but with an additional view on the left of the label
    ///
    /// Parameter:
    ///  - label: A String or LocalizedStringKey representing the text displayed on the button
    ///  - subLabel: An optionnal String or LocalizedStringKey representing a smaller text displayed on the button
    ///  - value: a String representing the value to be displayed on the right of the button
    ///  - action: method or closure property that does something when a user clicks or taps the button
    ///  - leftView: A View
    ///
    /// ### Usage
    ///
    /// ```swift
    ///     ButtonValueCell(label: "Connected as: ",
    ///         value: user.name,
    ///         action: changeUser,
    ///         leftView: {
    ///          Image(systemName: "person.crop.circle.badge.moon")
    ///             .foregroundColor(.white)
    ///         }
    ///     )
    ///     ButtonValueCell(label: "Connected as: ",
    ///         subLabel: "click to change",
    ///         value: user.name,
    ///         action: changeUser,
    ///         leftView: {
    ///          Image(systemName: "person.crop.circle.badge.moon")
    ///            .foregroundColor(.white)
    ///         }
    ///     )
    /// ```
    public init(label: String = "",
                subLabel: String = "",
                value: String = "",
                action: @escaping (() -> ()),
                leftView: (() -> LeftView)? = nil) {
        self.action = action
        self.content = leftView?()
        if (leftView != nil) {
            alignment = .leading
        } else {
            alignment = .center
        }
        
        labelText = Text(label)
        if !value.isEmpty {
            valueText = Text(value)
        }
        if !subLabel.isEmpty {
            subLabelText = Text(subLabel)
        }
    }

    public var body: some View {
        Button(action: {
            isClicked.toggle()
            action()
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                isClicked.toggle()
            }
        }) {
            HStack {
                content
                VStack(alignment: .leading) {
                    if clickedColor != .secondary {
                        labelText
                            .foregroundColor(isClicked ? clickedColor : primaryColor)
                            .primaryFont(size: .L, weight: .medium)
                            .padding(.trailing)
                    } else {
                        labelText
                            .foregroundColor(primaryColor)
                            .primaryFont(size: .L, weight: .medium)
                            .padding(.trailing)
                    }
                    if subLabelText != nil {
                        if clickedColor != .secondary {
                            subLabelText
                                .foregroundColor(isClicked ? clickedColor : secondaryColor)
                                .primaryFont(size: .S, weight: .medium)
                        } else {
                            subLabelText
                                .foregroundColor(secondaryColor)
                                .primaryFont(size: .S, weight: .medium)
                        }
                    }
                }
                Spacer()
                if valueText != nil {
                    if clickedColor != .secondary {
                        valueText
                            .foregroundColor(isClicked ? clickedColor : secondaryColor)
                            .primaryFont(size: .L, weight: .medium)
                    } else {
                        valueText
                            .foregroundColor(secondaryColor)
                            .primaryFont(size: .L, weight: .medium)
                    }
                }
                Image(systemName: "chevron.right")
                    .foregroundColor(isClicked ? .success : .primaryText)
                    .primaryFont(size: .XL, weight: .medium)
            }
        }
        .foregroundColor(.primaryText)
    }
}

public extension ButtonValueCell where LeftView == EmptyView {
    /// Default initialiser
    ///
    /// Parameter:
    ///  - label: A String or LocalizedStringKey representing the text displayed on the button
    ///  - subLabel: An optionnal String or LocalizedStringKey representing a smaller text displayed on the button
    ///  - value: a String representing the value to be displayed on the right of the button
    ///  - action: method or closure property that does something when a user clicks or taps the button
    ///
    /// ### Usage
    ///
    /// ```swift
    ///    ButtonValueCell(label: "Connected as: ",
    ///        value: user.name,
    ///        action: changeUser
    ///    )
    ///    ButtonValueCell(label: "Connected as: ",
    ///        subLabel: "click to change",
    ///        value: user.name,
    ///        action: changeUser
    ///    )
    /// ```
    init(label: String = "",
         subLabel: String = "",
         value: String = "",
         action: @escaping (() -> ())) {
        self.action = action
        content = nil
        alignment = .center
        labelText = Text(label)
        if !value.isEmpty {
            valueText = Text(value)
        }
        if !subLabel.isEmpty {
            subLabelText = Text(subLabel)
        }
    }
}

struct ButtonValueCell_Previews: PreviewProvider {
    let action = {
        print("pressed")
    }

    static var previews: some View {
        VStack {
            ButtonValueCell(action: {})
            ButtonValueCell(label: "Label", action: {})
            ButtonValueCell(label: "Label", value: "value", action: {})
                .primaryColor(.red)
                .secondaryColor(.blue)
                .clickedColor(.yellow)
            ButtonValueCell(label: "Label", subLabel: "subLabel", value: "value", action: {})
                .primaryColor(.red)
                .secondaryColor(.blue)
                .clickedColor(.yellow)
            ButtonValueCell(label: "Label",
                       action: {},
                       leftView: {
                        Image(systemName: "square.fill")
                            .foregroundColor(.white)
                            .primaryFont(size: .XXL, weight: .medium)
                       })
            ButtonValueCell(label: "Label",
                            subLabel: "subLabel",
                            action: {},
                            leftView: {
                                Image(systemName: "square.fill")
                                    .foregroundColor(.white)
                                    .primaryFont(size: .XXL, weight: .medium)
                            })
            ButtonValueCell(label: "Label",
                            value: "value",
                       action: {},
                       leftView: {
                        Image(systemName: "square.fill")
                            .foregroundColor(.white)
                            .primaryFont(size: .XXL, weight: .medium)
                       })
                .primaryColor(.green)
                .secondaryColor(.yellow)
                .clickedColor(.yellow)
            ButtonValueCell(label: "Label",
                            subLabel: "subLabel",
                            value: "value",
                            action: {},
                            leftView: {
                                Image(systemName: "square.fill")
                                    .foregroundColor(.white)
                                    .primaryFont(size: .XXL, weight: .medium)
                            })
        }
        .preferredColorScheme(.dark)
    }
}
