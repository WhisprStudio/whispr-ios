//
//  ListView.swift
//  Whispr
//
//  Created by Paul Erny on 07/07/2021.
//

import SwiftUI

/// Format of the content to be displayed on a ``ListView``
///
/// Composed of an array of Views, and an optional header and footer Strings.
///
/// ```swift
///    Section(items: [
///                AnyView(Text("1")),
///                AnyView(Text("2")),
///                AnyView(Text("3"))
///            ],
///            header: "header text",
///            footer: "footer text"
///    )
/// ```
public struct Section: Identifiable {
    public let id = UUID()
    var items: [AnyView]
    var header: String
    var footer: String

    /// Default initializer
    ///
    /// Parameter:
    ///  - items: A list of Views to be displayed as rows of the ``ListView``
    ///  - header: String to be displayed as the section's header
    ///  - footer: String to be displayed as the section's footer
    ///
    /// ### Usage
    ///
    /// ```swift
    ///    Section(items: [
    ///                AnyView(Text("1")),
    ///                AnyView(Text("2")),
    ///                AnyView(Text("3"))
    ///            ]
    ///    )
    ///    Section(items: [
    ///                AnyView(Text("4")),
    ///                AnyView(Text("5")),
    ///                AnyView(Text("6"))
    ///            ],
    ///            header: "header text",
    ///            footer: "footer text"
    ///    )
    /// ```
    public init(items: [AnyView], header: String = "", footer: String = "") {
        self.items = items
        self.header = header
        self.footer = footer
    }
}
/// A container that presents rows of data arranged in a single column, optionally providing the ability
/// to select one or more members.
///
/// You create a ListView by providing a list of ``Section``, followed by the ``ListStyle`` that you want for your list
/// and weather or not you want it on fullscreen or not.
/// --- for example:
///
/// ```swift
///    ListView(sections: [firstSection, secondSection],
///             style: .rounded)
/// ```
///
/// This will display each section of the list in the desired style in the following format:
///  - Header of section 1 (if any)
///  - Content of section 1
///  - Footer of section 1 (if any)
///
///  - BLANK
///
///  - Header of section 2 (if any)
///  - Content of section 2
///  - Footer of section 2 (if any)
///
/// The list will be made scrollable if the the content doesn't fit on the screen.
///
/// ### Styling ButtonCells
/// ```swift
///     ButtonCell(label: "label", action: {})
///         .backgroundColor(.purple)
///         .separatorColor(.red)
///         .primaryColor(.blue)
/// ```
/// #### backgroundColor
///
/// ```swift
///     func backgroundColor(_ color: Color) -> some View
/// ```
/// When applied, replaces the background color of every section with the given parameter but leaves
/// the background of the list (space between sections) untouched
///
/// #### separatorColor
///
/// ```swift
///     func separatorColor(_ color: Color) -> some View
/// ```
/// When applied, replaces the color of the line between rows with the given parameter
///
/// #### primaryColor
///
/// ```swift
///     func primaryColor(_ color: Color) -> some View
/// ```
/// When applied, replaces the header and footer text's color of every section with the given parameter
public struct ListView: View {
    
    var sections: [Section]
    var style: ListStyle
    var fullscreen: Bool
    
    /// Determines the style of the list's sections
    public enum ListStyle {
        /// Encapsulates each section in a box with rounded corners.
        /// Border's color can be changed by applying the `primaryColor(_ color: Color)` modifier
        case rounded
        /// Makes each section as wide as the list's parent container.
        /// The color of the top and bottom separators can be changed by applying the `primaryColor(_ color: Color)` modifier
        case plain
    }

    /// Default initializer
    ///
    /// Parameter:
    ///  - sections: A list of ``Section`` to be displayed
    ///  - style: ``ListStyle`` (rounded by default)
    ///  - fullscreen: false by default
    ///
    /// ### Usage
    ///
    /// ```swift
    ///    ListView(sections: [firstSection, secondSection])
    ///    ListView(sections: [firstSection, secondSection],
    ///             style: .plain,
    ///             fullscreen: true
    ///    )
    /// ```
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
