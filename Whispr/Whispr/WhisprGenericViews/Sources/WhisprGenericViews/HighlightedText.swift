//
//  SwiftUIView.swift
//  
//
//  Created by Paul Erny on 11/04/2022.
//

import SwiftUI

/// A view that displays one or more lines of read-only text with one or more differently colored words.
/// For  example:
///
/// ```swift
///    HighlightedText(text: "some highlighted text with multiple words",
///                    highlighted: ["highlighted", "multiple"],
///                    color: Color.red
///    )
/// ```
///
/// ### Styling HighlightedText
///
/// ```swift
///    DeleteCell(action: deleteContent)
///        .primaryFont(size: .XL, weight: .medium)
/// ```
/// #### deleteTextColor
///
/// ```swift
///     func primaryFont(size: FontSize, weight: FontWeight) -> some View
/// ```
/// When applied, replaces the color of the main text by the one specified in the primaryFont modifier declaration, sets the font size and weight to the ones given as parameters.
public struct HighlightedText: View {
    var text: String
    var highlighted: [String]
    var color: Color
    private var finalText: Text!
    
    /// Default initializer
    ///
    /// Parameter:
    ///  - text: String representing the complete text to be displayed
    ///  - highlighted: [String] array conaining all words to be highlighted in the text
    ///  - color: Color of the highlighted words
    ///
    /// ### Usage
    ///
    /// ```swift
    ///    HighlightedText(text: "some highlighted text with multiple words",
    ///                    highlighted: ["highlighted", "multiple"],
    ///                    color: Color.red
    ///    )
    /// ```
    public init(text: String, highlighted: [String], color: Color) {
        self.text = text
        self.highlighted = highlighted
        self.color = color
        
        for strWord in text.split(separator: " ") {
            var textWord = Text(strWord)
            if highlighted.contains(String(strWord)) {
                textWord = textWord.foregroundColor(color)
            }
            finalText = (finalText == nil ? textWord : finalText + Text(" ") + textWord)
        }
    }
    
    public var body: some View {
        finalText
    }
}

struct HighlightedText_Previews: PreviewProvider {
    static var previews: some View {
        HighlightedText(text: "some highlighted text with multiple words", highlighted: ["highlighted", "multiple"], color: Color.red)
    }
}
