//
//  SwiftUIView.swift
//  
//
//  Created by Paul Erny on 05/09/2021.
//

import SwiftUI

private struct PrimaryColorKey: EnvironmentKey {
    static let defaultValue: Color = .primary
}

private struct SecondaryColorKey: EnvironmentKey {
    static let defaultValue: Color = .secondary
}

private struct ClickedColorKey: EnvironmentKey {
    static let defaultValue: Color = .secondary
}

public extension EnvironmentValues {
    var primaryColor: Color {
        get { self[PrimaryColorKey.self] }
        set { self[PrimaryColorKey.self] = newValue }
    }

    var secondaryColor: Color {
        get { self[SecondaryColorKey.self] }
        set { self[SecondaryColorKey.self] = newValue }
    }

    var clickedColor: Color {
        get { self[ClickedColorKey.self] }
        set { self[ClickedColorKey.self] = newValue }
    }
}

public extension View {
    func primaryColor(_ color: Color) -> some View {
        environment(\.primaryColor, color)
    }
    
    func secondaryColor(_ color: Color) -> some View {
        environment(\.secondaryColor, color)
    }
    
    func clickedColor(_ color: Color) -> some View {
        environment(\.clickedColor, color)
    }
}
