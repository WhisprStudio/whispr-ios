//
//  File.swift
//  
//
//  Created by Paul Erny on 05/03/2022.
//

import SwiftUI

//MARK: - SwiftUI
protocol FontModifier: ViewModifier {
    var weight: FontWeight { get set }
    var size: FontSize { get set }
    var modifier: FontType { get set }
}

enum FontWeight: String {
    case regular = "Regular", medium = "Medium", thin = "Thin", semiBold = "SemiBold"
}

// TODO: add more ? (semi bold, extra bold, bold italic, ...)
enum FontType: String {
    case none = "", italic = "Italic", bold = "Bold"
}

enum FontSize: CGFloat {
    case XXL = 45, XL = 36, L = 28, M = 20, S = 17, XS = 15, XXS = 13, XXXS = 11
}

struct PrimaryFontModifier: ViewModifier {
    var weight: FontWeight = .medium
    var size: FontSize = .XS
    var modifier: FontType = .none
    
    func body(content: Content) -> some View {
        let fontAttribute = weight == .thin ? weight.rawValue + FontType.italic.rawValue : weight.rawValue
        return content
            .font(.custom("Barlow-\(fontAttribute)", size: size.rawValue))
//            .font(.system(size: size.rawValue, weight: .medium, design: .default))
            .foregroundColor(.primaryText)
    }
    
}

struct SecondaryFontModifier: FontModifier {
    var weight: FontWeight = .medium
    var size: FontSize = .XS
    var modifier: FontType = .none
    
    func body(content: Content) -> some View {
        return content
            .font(.system(size: size.rawValue, weight: .medium, design: .default))
            .foregroundColor(.white)
    }
}

extension View {
    func primaryFont(size: FontSize, weight: FontWeight) -> some View {
        self.modifier(PrimaryFontModifier(weight: weight, size: size))
    }
    
    func secondaryFont(size: FontSize, weight: FontWeight) -> some View {
        self.modifier(SecondaryFontModifier(weight: weight, size: size))
    }
}
