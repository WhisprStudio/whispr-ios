//
//  ListView.swift
//  Whispr
//
//  Created by Paul Erny on 07/07/2021.
//

import SwiftUI

public struct Section: Identifiable {
    public let id = UUID()
    var items: [AnyView]
    var header: String
    var footer: String

    public init(items: [AnyView], header: String = "", footer: String = "") {
        self.items = items
        self.header = header
        self.footer = footer
    }
}

public struct ListView: View {
    
    var sections: [Section]
    var style: ListStyle
    var fullscreen: Bool
    
    public enum ListStyle {
        case rounded, plain
    }

    public init(sections: [Section], style: ListStyle = .rounded, fullscreen: Bool = false) {
        self.sections = sections
        self.style = style
        self.fullscreen = fullscreen
    }
    
    @Environment(\.primaryColor) var primaryColor : Color
    @Environment(\.backgroundColor) var backgroundColor : Color
    @Environment(\.separatorColor) var separatorColor : Color
    
    @ViewBuilder func view() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach( Array(sections.enumerated()), id: \.offset) { index, section in
                    if style == .rounded {
                        if index == 0 {
                            RoundedListView(section: section, primaryColor: primaryColor, backgroundColor: backgroundColor, separatorColor: separatorColor)
                                .padding(.bottom)
                        } else {
                            RoundedListView(section: section, primaryColor: primaryColor, backgroundColor: backgroundColor, separatorColor: separatorColor)
                                .padding(.bottom)
                                .padding(.top)
                        }
                    } else {
                        if index == 0 {
                            PlainListView(section: section, primaryColor: primaryColor, backgroundColor: backgroundColor, separatorColor: separatorColor)
                                .padding(.bottom)
                        } else {
                            PlainListView(section: section, primaryColor: primaryColor, backgroundColor: backgroundColor, separatorColor: separatorColor)
                                .padding(.bottom)
                                .padding(.top)
                        }
                    }
                }
            }
            .padding(.bottom, 35)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.background.edgesIgnoringSafeArea(.all))
    }

    public var body: some View {
        if fullscreen {
            view()
                .padding(.top)
                .edgesIgnoringSafeArea(.all)
        } else {
            view()
//            VStack {
//                RoundedListView(section: sections[0], primaryColor: primaryColor, backgroundColor: backgroundColor, separatorColor: separatorColor)
//                    .padding(.bottom)
//                RoundedListView(section: sections[1], primaryColor: primaryColor, backgroundColor: backgroundColor, separatorColor: separatorColor)
//                    .padding(.bottom)
//            }
        }
    }
}

struct ListDivider: View {
    var height: CGFloat = 2
    var separatorColor: Color = Color.primaryText
    var body: some View {
        Rectangle()
            .fill(separatorColor)
            .frame(height: height)
            .padding(.leading, 30)
            .padding(.trailing, 30)
    }
}

struct Cell_Previews: PreviewProvider {
    static var previews: some View {
        ListView(sections: [Section(items: [AnyView(Text("1")), AnyView(Text("2")), AnyView(Text("3"))], header: "header1", footer: "footer1"),
                            Section(items: [AnyView(Text("4")), AnyView(Text("5")), AnyView(Text("6"))], header: "header2", footer: "footer2"),
                            Section(items: [AnyView(Text("7")), AnyView(Text("8")), AnyView(Text("9"))], header: "header3", footer: "footer3"),
                            Section(items: [AnyView(Text("10")), AnyView(Text("11")), AnyView(Text("12"))], header: "header4", footer: "footer4"),
        ], style: .rounded)
        .backgroundColor(.purple)
        .separatorColor(.red)
        .primaryColor(.blue)
        .preferredColorScheme(.dark)
    }
}
