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

private struct SeparotorColorKey: EnvironmentKey {
    static let defaultValue: Color = .primary
}

private struct BackgroundColorKey: EnvironmentKey {
    static let defaultValue: Color = .secondary
}

private struct TextInputColorKey: EnvironmentKey {
    static let defaultValue: Color = .primary
}

private struct SaveTextColorKey: EnvironmentKey {
    static let defaultValue: Color = .primary
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
    
    var separatorColor: Color {
        get { self[SeparotorColorKey.self] }
        set { self[SeparotorColorKey.self] = newValue }
    }
    
    var backgroundColor: Color {
        get { self[BackgroundColorKey.self] }
        set { self[BackgroundColorKey.self] = newValue }
    }
    
    var textInputColor: Color {
        get { self[TextInputColorKey.self] }
        set { self[TextInputColorKey.self] = newValue }
    }

    var saveTextColor: Color {
        get { self[SaveTextColorKey.self] }
        set { self[SaveTextColorKey.self] = newValue }
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

    func separatorColor(_ color: Color) -> some View {
        environment(\.separatorColor, color)
    }

    func backgroundColor(_ color: Color) -> some View {
        environment(\.backgroundColor, color)
    }
    
    func textInputColor(_ color: Color) -> some View {
        environment(\.textInputColor, color)
    }

    func saveTextColor(_ color: Color) -> some View {
        environment(\.saveTextColor, color)
    }
}
