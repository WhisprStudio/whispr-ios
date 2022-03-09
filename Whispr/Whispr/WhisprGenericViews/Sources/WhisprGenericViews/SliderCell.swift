//
//  SliderCell.swift
//  Whispr
//
//  Created by Paul Erny on 02/09/2021.
//

import SwiftUI

/// A control for selecting a value from a linear range of floating point values.
///
/// A premade customization of the ``CustomSlider`` with preset shapes and that selects integer values from 0 to 100. The ability to add a custom label above the slider has also been implemented.
/// Therefore it takes less parameters than the original CustomSlider. For example:
///
/// ```swift
///    SliderCell(value: $value, onValueChanged: saveNewValue, label: "My label")
///        .frame(maxWidth: .infinity)
/// ```
///
/// ### Styling DeleteCell

/// ```swift
///    SliderCell(value: $value, onValueChanged: saveNewValue, label: "My label")
///        .primaryColor(.red)
///        .secondaryColor(.green)
/// ```
/// #### primaryColor
///
/// ```swift
///     func primaryColor(_ color: Color) -> some View
/// ```
/// When applied, replaces the color of the label and the slider's track with the given parameter
///
/// #### secondaryColor
///
/// ```swift
///     func secondaryColor(_ color: Color) -> some View
/// ```
/// When applied, replaces the color of the left part of the track (between the start and the moving part of the slider) with the given parameter
public struct SliderCell: View {
    @Binding var value: CGFloat
    var onEditingChanged: ((Bool) -> ())
    var label: String
    private let thumbRadius: CGFloat = 30

    @Environment(\.primaryColor) var primaryColor : Color
    @Environment(\.secondaryColor) var secondaryColor : Color
    
    /// Creates a Slider with an integrated label
    ///
    /// Parameter:
    ///  - value: Binding to a CGFloat holding the slider's current value
    ///  - onValueChanged: method or closure property that gets called every time the value changes
    ///  - label: A String or LocalizedStringKey representing the text displayed above the slider
    public init(value: Binding<CGFloat>, onValueChanged: @escaping ((Bool) -> ()), label: String) {
        self._value = value
        self.onEditingChanged = onValueChanged
        self.label = label
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .padding(.leading, 5)
                .foregroundColor(primaryColor)
                .primaryFont(size: .L, weight: .medium)
            CustomSlider(value: $value,
                            in: 0...100,
                            step: 1,
                            onEditingChanged: onEditingChanged,
                            track: {
                                Capsule()
                                    .foregroundColor(primaryColor)
                                    .frame(width: 335, height: 10)
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

struct SliderCellPreviewContainer: View {
    @State var value: CGFloat = 0
    var onEditingChanged: ((Bool) -> ()) = {_ in }
    var label: String = "Volume"

    public var body: some View {
        VStack {
            SliderCell(value: $value, onValueChanged: onEditingChanged, label: label)
                .frame(maxWidth: .infinity)
            Text("Current slider value: \(value, specifier: "%.2f")")
        }
        .primaryColor(.disabledText)
        .secondaryColor(.whisprYellow)
        .background(Color.background)
    }
}

struct SliderCell_Previews: PreviewProvider {
    static var previews: some View {
        SliderCellPreviewContainer()
            .preferredColorScheme(.dark)
    }
}
