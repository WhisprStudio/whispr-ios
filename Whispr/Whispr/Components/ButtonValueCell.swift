//
//  ButtonValueCell.swift
//  
//
//  Created by Paul Erny on 22/10/2021.
//

import SwiftUI

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
