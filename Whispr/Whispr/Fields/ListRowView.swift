//
//  ListRowView.swift
//  Whispr
//
//  Created by Paul Erny on 01/09/2021.
//

import SwiftUI

struct ListRowView: View {
    var section: Section

    init(section: Section) {
        self.section = section
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<section.items.count) { index in
                if index != 0 {
                    ListDivider()
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
