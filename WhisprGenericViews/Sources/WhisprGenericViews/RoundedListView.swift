//
//  RoundedListView.swift
//  Whispr
//
//  Created by Paul Erny on 01/09/2021.
//

import SwiftUI

public struct RoundedListView: View {
    var section: Section
    var primaryColor : Color
    var backgroundColor : Color
    var separatorColor : Color

    public init(section: Section,
                primaryColor : Color = .primary,
                backgroundColor : Color = .secondary,
                separatorColor : Color = .primary) {
        self.section = section
        self.primaryColor = primaryColor
        self.backgroundColor = backgroundColor
        self.separatorColor = separatorColor
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !section.header.isEmpty {
                Text(section.header.capitalized )
                    .foregroundColor(primaryColor)
                    .primaryFont(size: .M, weight: .medium)
            }
            ListRowView(section: section, separatorColor: separatorColor)
                .background(backgroundColor)
                .addBorder(separatorColor, width: 2, cornerRadius: 15)
                .padding(.top, 5)
                .padding(.bottom, 5)
            if !section.footer.isEmpty {
                Text(section.footer.capitalized)
                    .foregroundColor(primaryColor)
                    .primaryFont(size: .S, weight: .medium)
            }
        }
        .padding(.leading)
        .padding(.trailing)
    }
}

extension View {
    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
             .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}

struct RoundedListView_Previews: PreviewProvider {
    static var previews: some View {
        RoundedListView(section: Section(items: [AnyView(Text("1")), AnyView(Text("2")), AnyView(Text("3"))], header: "header1", footer: "footer1"))
            .preferredColorScheme(.dark)
    }
}
