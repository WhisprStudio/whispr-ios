//
//  PlainListView.swift
//  Whispr
//
//  Created by Paul Erny on 01/09/2021.
//

import SwiftUI

struct PlainListView: View {
    var section: Section
    var primaryColor : Color
    var backgroundColor : Color
    var separatorColor : Color

    init(section: Section,
                primaryColor : Color = .primary,
                backgroundColor : Color = .secondary,
                separatorColor : Color = .primary) {
        self.section = section
        self.primaryColor = primaryColor
        self.backgroundColor = backgroundColor
        self.separatorColor = separatorColor
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !section.header.isEmpty {
                Text(section.header)
                    .foregroundColor(primaryColor)
                    .primaryFont(size: .M, weight: .medium)
                    .padding(.bottom, 5)
                    .padding(.leading)
            }
            Rectangle()
                .fill(separatorColor)
                .frame(height: 2)
            ListRowView(section: section, separatorColor: separatorColor)
                .background(backgroundColor)
            Rectangle()
                .fill(separatorColor)
                .frame(height: 2)
            if !section.footer.isEmpty {
                Text(section.footer)
                    .foregroundColor(primaryColor)
                    .primaryFont(size: .S, weight: .medium)
                    .padding(.top, 5)
                    .padding(.leading)
            }
        }
    }
}

struct PlainListView_Previews: PreviewProvider {
    static var previews: some View {
        PlainListView(section: Section(items: [AnyView(Text("1")), AnyView(Text("2")), AnyView(Text("3"))], header: "header1", footer: "footer1"))
            .preferredColorScheme(.dark)
    }
}
