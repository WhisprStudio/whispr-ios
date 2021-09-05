//
//  ButtonCell.swift
//  Whispr
//
//  Created by Paul Erny on 03/07/2021.
//

import SwiftUI

public struct ButtonCell<LeftView: View, RightView: View>: View {
    private var label: String
    private var subLabel: String
    private var action: (() -> ())
    private let content: LeftView?
    private let rightView: RightView?
    @State private var isClicked: Bool = false
    private let alignment: HorizontalAlignment!
    
    public init(label: String = "",
         subLabel: String = "",
         action: @escaping (() -> ()),
         leftView: (() -> LeftView)? = nil,
         rightView: (() -> RightView)? = nil) {
        self.label = label
        self.subLabel = subLabel
        self.action = action
        self.content = leftView?()
        self.rightView = rightView?()
        if (leftView != nil) {
            alignment = .leading
        } else {
            alignment = .center
        }
    }

    public var body: some View {
        Button(action: {
            isClicked.toggle()
            action()
        }) {
            HStack {
                content
//                    .padding(.leading)
                if (content != nil) {
                    Spacer()
                }
                VStack(alignment: alignment) {
                    Text(label)
                        .foregroundColor(isClicked ? .success : .primaryText)
                        .primaryFont(size: .L, weight: .medium)
                        .padding(.trailing)
                    if !(subLabel.isEmpty) {
                        Text(subLabel)
                            .foregroundColor(isClicked ? .success : .disabledText)
                            .primaryFont(size: .S, weight: .medium)
                            .padding(.trailing)
                    }
                }
                if (rightView != nil && content == nil) {
                    Spacer()
                }
                rightView
            }
        }
        .foregroundColor(.primaryText)
//        .frame(minWidth: 0, maxWidth: 300)
//        .padding()
//        .padding(.leading, 10)
//        .padding(.trailing, 10)
//        .overlay(
//            RoundedRectangle(cornerRadius: 15)
//                .stroke(isClicked ? Color.success : Color.primaryText, lineWidth: 2)
//        )
//        .background(Color.background)
    }
}

public extension ButtonCell where LeftView == EmptyView {
    init(label: String = "",
         subLabel: String = "",
         action: @escaping (() -> ()),
         rightView: (() -> RightView)? = nil) {
        self.label = label
        self.subLabel = subLabel
        self.action = action
        content = nil
        self.rightView = rightView?()
        alignment = .center
    }
}

public extension ButtonCell where RightView == EmptyView {
    init(label: String = "",
         subLabel: String = "",
         action: @escaping (() -> ()),
         leftView: (() -> LeftView)? = nil) {
        self.label = label
        self.subLabel = subLabel
        self.action = action
        rightView = nil
        content = leftView?()
        alignment = .center
    }
}

public extension ButtonCell where RightView == EmptyView, LeftView == EmptyView {
    init(label: String = "",
         subLabel: String = "",
         action: @escaping (() -> ())) {
        self.label = label
        self.subLabel = subLabel
        self.action = action
        rightView = nil
        content = nil
        alignment = .center
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
            ButtonCell(label: "label",
                       action: {},
                       leftView: {
                        Image("portable2")
                            .resizable()
                            .frame(width: 50, height: 50)
                       },
                       rightView: {
                        Image(systemName: "chevron.right")
                            .primaryFont(size: .L, weight: .regular)
                       })
            ButtonCell(label: "label",
                       subLabel: "subLabel",
                       action: {},
                       leftView: {
                        Image("portable2")
                            .resizable()
                            .frame(width: 50, height: 50)
                       },
                       rightView: {
                        Image(systemName: "chevron.right")
                            .primaryFont(size: .L, weight: .regular)
                       })
            ButtonCell(label: "label",
                       action: {},
                       rightView: {
                        Image(systemName: "chevron.right")
                            .primaryFont(size: .L, weight: .regular)
                       })
            ButtonCell(label: "label",
                       subLabel: "subLabel",
                       action: {},
                       rightView: {
                        Image(systemName: "chevron.right")
                            .primaryFont(size: .L, weight: .regular)
                       })
        }
        .preferredColorScheme(.dark)
    }
}
