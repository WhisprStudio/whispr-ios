//
//  SwitchCell.swift
//  Whispr
//
//  Created by Paul Erny on 22/10/2021.
//

import SwiftUI

/// A control that toggles between on and off states.
///
/// You create a SwitchCell by providing an action, label, sublabel and a binding to hold the value of the state.
/// The action is either a method or closure property that does something when a user clicks or taps
/// the button. The label and sublabel are strings that describe the button's action --- for
/// example:
///
/// ```swift
///     SwitchCell(label: "Wi-Fi",
///                value: $isWifiEnabled,
///                onValueChanged: toggleWiFi
///     )
///     SwitchCell(label: "Bluetooth",
///                subLabel: "Toggle On / Off",
///                value: $value,
///                onValueChanged: toggleBluetooth
///     )
/// ```
///
/// ### Styling SwitchCell
///
/// For the styling of the SwitchCell, you have access to one modifier
/// ```swift
///     SwitchCell(label: "Wi-Fi",
///                value: $isWifiEnabled,
///                onValueChanged: toggleWiFi
///     )
///         .primaryColor(.green)
/// ```
/// #### primaryColor
///
/// ```swift
///     func primaryColor(_ color: Color) -> some View
/// ```
/// When applied, replaces the background color of the switch **when turned on** with the given parameter
public struct SwitchCell: View {
    private var label: Text
    private var subLabel: Text?
    @Binding var value: Bool
    var onValueChanged: ((Bool) -> ())
    
    @Environment(\.primaryColor) var primaryColor : Color
    
    /// Creates a SwitchCell with a label and optionnal sublabel
    ///
    /// Parameter:
    ///  - label: A String or LocalizedStringKey representing the text displayed on the switch
    ///  - subLabel: An optionnal String or LocalizedStringKey representing a smaller text displayed on the switch
    ///  - value: Binding to a Bool holding the value of the switch
    ///  - action: method or closure property that does something when a user clicks or taps the switch
    ///
    /// ### Usage
    ///
    /// ```swift
    ///     SwitchCell(label: "Wi-Fi",
    ///                value: $isWifiEnabled,
    ///                onValueChanged: toggleWiFi
    ///     )
    ///     SwitchCell(label: "Bluetooth",
    ///                subLabel: "Toggle On / Off",
    ///                value: $value,
    ///                onValueChanged: toggleBluetooth
    ///     )
    /// ```
    public init(label: String,
                subLabel: String = "",
                value: Binding<Bool>,
                onValueChanged: @escaping ((Bool) -> ())) {
        self.label = Text(label)
        if !subLabel.isEmpty {
            self.subLabel = Text(subLabel)
        }
        self._value = value
        self.onValueChanged = onValueChanged
    }
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                label
                    .primaryFont(size: .L, weight: .medium)
                if subLabel != nil {
                    subLabel
                        .primaryFont(size: .S, weight: .medium)
                }
            }
            if primaryColor != .primary {
                Toggle("", isOn: $value)
                    .primaryFont(size: .L, weight: .medium)
                    .onChange(of: value, perform: { value in
                        onValueChanged(value)
                    })
                    .toggleStyle(SwitchToggleStyle(tint: primaryColor))
            } else {
                Toggle("", isOn: $value)
                    .primaryFont(size: .L, weight: .medium)
                    .onChange(of: value, perform: { value in
                        onValueChanged(value)
                    })
            }
        }
    }
}

struct SwitchCellPreviewContainer: View {
    @State var value: Bool = false
    var onEditingChanged: ((Bool) -> ()) = {_ in }
    var label: String = "label"
    var subLabel: String = ""

    var body: some View {
        VStack {
            SwitchCell(label: "label", value: $value, onValueChanged: {_ in })
            SwitchCell(label: "label", subLabel: "subLabel", value: $value, onValueChanged: {_ in})
            Text("\(String(value))")
        }
        .primaryColor(Color.yellow)
        .background(Color.background)
    }
}

struct SwitchCell_Previews: PreviewProvider {
    static var previews: some View {
        SwitchCellPreviewContainer()
            .preferredColorScheme(.dark)
    }
}
