//
//  ListView.swift
//  Whispr
//
//  Created by Paul Erny on 07/07/2021.
//

import SwiftUI

struct Section: Identifiable {
    let id = UUID()
    var items: [AnyView]
    var header: String
    var footer: String

    init(items: [AnyView], header: String = "", footer: String = "") {
        self.items = items
        self.header = header
        self.footer = footer
    }
}

fileprivate struct ListRow: View {
    
    var section: Section
    
    init(section: Section) {
        self.section = section
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if !section.header.isEmpty {
                Text(section.header.capitalized )
                    .primaryFont(size: .L, weight: .medium)
                    .padding(.top)
            }
            ForEach(0..<section.items.count) { index in
                section.items[index]
                    .frame(maxWidth: .infinity)
            }
            if !section.footer.isEmpty {
                Text(section.footer.capitalized)
                    .primaryFont(size: .M, weight: .medium)
            }
        }
    }
}

struct ListView: View {
    
    var sections: [Section]
    
    init(sections: [Section]) {
        self.sections = sections
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(sections) { section in
                    ListRow(section: section)
                }
                .padding(.top)
                .padding(.bottom)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.all)
    }
}

struct Cell_Previews: PreviewProvider {
    static var previews: some View {
        ListView(sections: [Section(items: [AnyView(Text("1")), AnyView(Text("2")), AnyView(Text("3"))], header: "header1", footer: "footer1"),
                            Section(items: [AnyView(Text("4")), AnyView(Text("5")), AnyView(Text("6"))], header: "header2", footer: "footer2"),
                            Section(items: [AnyView(Text("7")), AnyView(Text("8")), AnyView(Text("9"))], header: "header3", footer: "footer3"),
        ])
        .preferredColorScheme(.dark)
    }
}
