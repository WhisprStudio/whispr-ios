//
//  File.swift
//  
//
//  Created by Victor maurin on 11/04/2022.
//

import Foundation
import SwiftUI

struct FilledButton: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(configuration.isPressed ? .gray : .white)
            .padding()
            .background(isEnabled ? Color.accentColor : .gray)
            .cornerRadius(8)
    }
}

struct OutlineButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(configuration.isPressed ? .success : .whisprYellow)
            .padding()
            .background(
                RoundedRectangle(
                    cornerRadius: 8,
                    style: .circular
                ).stroke(Color.whisprYellow)
        )
    }
}
