//
//  ConfigSwitchCell.swift
//  Whispr
//
//  Created by Paul Erny on 22/10/2021.
//

import SwiftUI

public struct ConfigSwitchCell: View {
    private var label: Text
    private var subLabel: Text?
    @Binding var value: Bool
    var onValueChanged: ((Bool) -> ())
    
    @Environment(\.primaryColor) var primaryColor : Color
    
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

struct ConfigSwitchCellPreviewContainer: View {
    @State var value: Bool = false
    var onEditingChanged: ((Bool) -> ()) = {_ in }
    var label: String = "label"
    var subLabel: String = ""

    var body: some View {
        VStack {
            ConfigSwitchCell(label: "label", value: $value, onValueChanged: {_ in })
            ConfigSwitchCell(label: "label", subLabel: "subLabel", value: $value, onValueChanged: {_ in})
            Text("\(String(value))")
        }
        .primaryColor(Color.yellow)
        .background(Color.background)
    }
}

struct ConfigSwitchCell_Previews: PreviewProvider {
    static var previews: some View {
        ConfigSwitchCellPreviewContainer()
            .preferredColorScheme(.dark)
    }
}
