//
//  ButtonCell.swift
//  Whispr
//
//  Created by Paul Erny on 03/07/2021.
//

import SwiftUI

public struct ButtonCell<LeftView: View, RightView: View>: View {
    private var action: (() -> ())
    private let content: LeftView?
    private let rightView: RightView?
    @State private var isClicked: Bool = false
    private let alignment: HorizontalAlignment!
    
    var labelText: Text
    private var subLabelText: Text?
    
    @Environment(\.primaryColor) var primaryColor : Color
    @Environment(\.secondaryColor) var secondaryColor : Color
    @Environment(\.clickedColor) var clickedColor : Color

    public init(label: String = "",
         subLabel: String = "",
         action: @escaping (() -> ()),
         leftView: (() -> LeftView)? = nil,
         rightView: (() -> RightView)? = nil) {
        self.action = action
        self.content = leftView?()
        self.rightView = rightView?()
        if (leftView != nil) {
            alignment = .leading
        } else if leftView == nil && rightView != nil {
            alignment = .leading
        } else {
            alignment = .center
        }
        
        labelText = Text(label)
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
                if (content != nil) {
                    Spacer()
                }
                VStack(alignment: alignment) {
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
                                .padding(.trailing)
                        } else {
                            subLabelText
                                .foregroundColor(secondaryColor)
                                .primaryFont(size: .S, weight: .medium)
                                .padding(.trailing)
                        }
                    }
                }
                if (rightView != nil && content == nil) {
                    Spacer()
                }
                rightView
            }
        }
        .foregroundColor(.primaryText)
    }
}

public extension ButtonCell where LeftView == EmptyView {
    init(label: String = "",
         subLabel: String = "",
         action: @escaping (() -> ()),
         rightView: (() -> RightView)? = nil) {
        self.action = action
        content = nil
        self.rightView = rightView?()
        alignment = .center
        labelText = Text(label)
        if !subLabel.isEmpty {
            subLabelText = Text(subLabel)
        }
    }
}

public extension ButtonCell where RightView == EmptyView {
    init(label: String = "",
         subLabel: String = "",
         action: @escaping (() -> ()),
         leftView: (() -> LeftView)? = nil) {
        self.action = action
        rightView = nil
        content = leftView?()
        alignment = .center
        labelText = Text(label)
        if !subLabel.isEmpty {
            subLabelText = Text(subLabel)
        }
    }
}

public extension ButtonCell where RightView == EmptyView, LeftView == EmptyView {
    init(label: String = "",
         subLabel: String = "",
         action: @escaping (() -> ())) {
        self.action = action
        rightView = nil
        content = nil
        alignment = .center
        labelText = Text(label)
        if !subLabel.isEmpty {
            subLabelText = Text(subLabel)
        }
    }
}

struct ButtonCell_Previews: PreviewProvider {
    let action = {
        print("pressed")
    }

    static var previews: some View {
        VStack {
            ButtonCell(action: {})
            ButtonCell(label: "label", action: {})
            ButtonCell(label: "label", subLabel: "subLabel", action: {})
                .primaryColor(.red)
                .secondaryColor(.blue)
                .clickedColor(.yellow)
            ButtonCell(label: "label",
                       action: {},
                       leftView: {
                        Image("portable2")
                            .resizable()
                            .frame(width: 50, height: 50)
                       })
            ButtonCell(label: "label",
                       subLabel: "subLabel",
                       action: {},
                       leftView: {
                        Image("portable2")
                            .resizable()
                            .frame(width: 50, height: 50)
                       })
                .primaryColor(.green)
                .secondaryColor(.yellow)
                .clickedColor(.yellow)
            ButtonCell(label: "label",
                       action: {},
                       leftView: {
                        Image("portable2")
                            .resizable()
                            .frame(width: 50, height: 50)
                       },
                       rightView: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.white)
                            .primaryFont(size: .L, weight: .regular)
                       })
            ButtonCell(label: "label",
                       subLabel: "subLabel",
                       action: {},
                       leftView: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.white)
                       },
                       rightView: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.white)
                            .primaryFont(size: .L, weight: .regular)
                       })
            ButtonCell(label: "label",
                       action: {},
                       rightView: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.white)
                            .primaryFont(size: .L, weight: .regular)
                       })
            ButtonCell(label: "label",
                       subLabel: "subLabel",
                       action: {},
                       rightView: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.white)
                            .primaryFont(size: .L, weight: .regular)
                       })
        }
        .preferredColorScheme(.dark)
    }
}
