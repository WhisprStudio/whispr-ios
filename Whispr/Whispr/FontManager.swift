//
//  FontManager.swift
//  Whispr
//
//  Created by Paul Erny on 09/06/2021.
//

import WhisprGenericViews
import SwiftUI

//MARK: - SwiftUI
struct PrimaryFontModifier: ViewModifier {
    var weight: FontWeight = .medium
    var size: FontSize = .XS
    var modifier: FontType = .none
    
    func body(content: Content) -> some View {
        let fontAttribute = weight == .thin ? weight.rawValue + FontType.italic.rawValue : weight.rawValue
        return content
            .font(.custom("Barlow-\(fontAttribute)", size: size.rawValue))
            .foregroundColor(.primaryText)
    }
    
}
