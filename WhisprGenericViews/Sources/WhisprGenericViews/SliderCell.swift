//
//  SliderCell.swift
//  Whispr
//
//  Created by Paul Erny on 02/09/2021.
//

import SwiftUI

public struct SliderCell: View {
    @Binding var value: CGFloat
    var onEditingChanged: ((Bool) -> ())
    var label: String
    var subLabel: String
    private let thumbRadius: CGFloat = 30

    @Environment(\.primaryColor) var primaryColor : Color
    @Environment(\.secondaryColor) var secondaryColor : Color

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(label)
                    .padding(.leading, 5)
                    .primaryFont(size: .L, weight: .medium)
            }
            HStack {
                CustomSlider(value: $value,
                                in: 0...100,
                                step: 1,
                                onEditingChanged: onEditingChanged,
                                track: {
                                    Capsule()
                                        .foregroundColor(primaryColor)
                                        .frame(width: .infinity, height: 10)
                                }, fill: {
                                    Capsule()
                                        .foregroundColor(secondaryColor)
                                }, thumb: {
                                    Capsule()
                                        .frame(width: thumbRadius, height: thumbRadius - 10)
                                        .foregroundColor(.white)
                                        .shadow(radius: thumbRadius / 1)
                                }, thumbSize: CGSize(width: thumbRadius, height: thumbRadius - 10))
            }
        }
    }
}

public struct SliderCellPreviewContainer: View {
    @State var value: CGFloat = 0
    var onEditingChanged: ((Bool) -> ()) = {_ in }
    var minimumValue: String = "0"
    var maximumValue: String = "100"
    var label: String = "Volume"
    var subLabel: String = ""

    public var body: some View {
        VStack {
            SliderCell(value: $value, onEditingChanged: onEditingChanged, label: label, subLabel: subLabel)
                .frame(maxWidth: .infinity)
            Text("Current slider value: \(value, specifier: "%.2f")")
        }
        .primaryColor(.disabledText)
        .secondaryColor(.WhisprYellow)
        .background(Color.background)
    }
}

struct SliderCell_Previews: PreviewProvider {
    static var previews: some View {
        SliderCellPreviewContainer()
            .preferredColorScheme(.dark)
    }
}
