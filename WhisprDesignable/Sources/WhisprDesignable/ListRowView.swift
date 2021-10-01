//
//  ListRowView.swift
//  Whispr
//
//  Created by Paul Erny on 01/09/2021.
//

import SwiftUI

public struct ListRowView: View {
    var section: Section
    var separatorColor: Color

    public init(section: Section, separatorColor : Color = .primary) {
        self.section = section
        self.separatorColor = separatorColor
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<section.items.count) { index in
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
        ListRowView(section: Section(items: []))
    }
}
