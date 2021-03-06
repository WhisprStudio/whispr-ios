//
//  ListRowView.swift
//  Whispr
//
//  Created by Paul Erny on 01/09/2021.
//

import SwiftUI

struct ListRowView: View {
    var section: Section
    var separatorColor: Color

    init(section: Section, separatorColor : Color = .primary) {
        self.section = section
        self.separatorColor = separatorColor
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<section.items.count, id: \.self) { index in
                if index != 0 {
                    ListDivider(separatorColor: separatorColor)
                }
                section.items[index]
                    .padding()
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct ListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ListRowView(section: Section(items: [AnyView(Text("1")), AnyView(Text("2")), AnyView(Text("3"))], header: "header1", footer: "footer1"))
    }
}
