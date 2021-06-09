//
//  FontManager.swift
//  Whispr
//
//  Created by Paul Erny on 09/06/2021.
//

import SwiftUI

//MARK: - SwiftUI
struct BarlowFontModifier: ViewModifier {
    var weight: FontWeight = .medium
    var size: FontSize = .XS
    var modifier: FontModifier = .none
    
    func body(content: Content) -> some View {
        let fontAttribute = weight == .thin ? weight.rawValue + FontModifier.italic.rawValue : weight.rawValue
        return content
            .font(.custom("Barlow-\(fontAttribute)", size: size.rawValue))
            .foregroundColor(.primaryText)
    }
    
}

public enum FontWeight: String {
    case regular = "Regular", medium = "Medium", thin = "Thin"
}

public enum FontModifier: String {
    case none = "", italic = "Italic"
}

public enum FontSize: CGFloat {
    case XXL = 45, XL = 36, L = 28, M = 20, S = 17, XS = 15, XXS = 13, XXXS = 11
}

extension View {
    func primaryFont(size: FontSize, weight: FontWeight) -> some View {
        self.modifier(BarlowFontModifier(weight: weight, size: size))
    }
}
