//
//  PlainListView.swift
//  Whispr
//
//  Created by Paul Erny on 01/09/2021.
//

import SwiftUI

public struct PlainListView: View {
    var section: Section

    public init(section: Section) {
        self.section = section
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !section.header.isEmpty {
                Text(section.header.capitalized )
                    .primaryFont(size: .L, weight: .medium)
                    .padding(.top)
                    .padding(.bottom, 5)
                    .padding(.leading)
            }
            Rectangle()
                .fill(Color.primaryText)
                .frame(height: 2)
            ListRowView(section: section)
                .background(Color.FieldBackground)
            Rectangle()
                .fill(Color.primaryText)
                .frame(height: 2)
            if !section.footer.isEmpty {
                Text(section.footer.capitalized)
                    .primaryFont(size: .M, weight: .medium)
                    .padding(.bottom)
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
