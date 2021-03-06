//
//  CustomSlider.swift
//  Whispr
//
//  Created by Paul Erny on 03/09/2021.
//

import SwiftUI

/// A control for selecting a value from a linear range of floating point values.
///
/// You create a ButtonCell by providing a binding that will contain the selected value,
/// the range of values, the step from which to increment values, three shapes respectively representing
/// the shape of the track, the filled part of the slider and the "button" that is used to pick a value.
/// You also provide a CGSize representing the width and height of said button to help with internal
/// computation. Lastly, you also pass an action as parameter.
/// The action is either a method or closure property that will automatically get called every time a new
/// value is selected.
/// Finnaly, two optionnal Texts can be provided, and if so, will be displayed on woth ends of the track
///
/// ### Implementation
///
/// ```swift
///    CustomSlider(value: $value,
///         in: 0...100,
///         step: 1,
///         minimumValueLabel: Text("Min"),
///         maximumValueLabel: Text("Max"),
///         onEditingChanged: { started in
///             print("started custom slider: \(started)")
///         }, track: {
///             Capsule()
///                 .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
///                 .frame(width: 200, height: 5)
///         }, fill: {
///             Capsule()
///             .foregroundColor(.blue)
///         }, thumb: {
///             Capsule()
///                 .frame(width: thumbRadius, height: thumbRadius)
///                 .foregroundColor(.white)
///                 .shadow(radius: thumbRadius / 1)
///         }, thumbSize: CGSize(width: thumbRadius, height: thumbRadius)
///    )
/// ```
///
/// Parameters:
///  - value: A Binding that will hold the selected value (Int, Float, Double, ...)
///  - in: (Optionnal) The range from which to pick values
///  - step: (Optionnal) The step at which to increment values
///  - minimumValueLabel: (Optionnal) A Text displayed to the left of the track
///  - maximumValueLabel: (Optionnal) A Text displayed to the right of the track
///  - onEditingChanged: (Optionnal) A method or closure property that does something when the value cahnges
///  - track: A shape representing the track on which the slider moves
///  - fill: A shape representing the left part of the track, between the start and the slider
///  - thumb: A shape representing the moving part of the slider
///  - thumbSize: CGSize representing the width and height of the thumb
public struct CustomSlider<Value, Track, Fill, Thumb>: View
where Value: BinaryFloatingPoint, Value.Stride: BinaryFloatingPoint, Track: View, Fill: View, Thumb: View {
    // the value of the slider, inside `bounds`
    @Binding var value: Value
    // range to which the thumb offset is mapped
    let bounds: ClosedRange<Value>
    // tells how discretely does the value change
    let step: Value
    // left-hand label
    let minimumValueLabel: Text?
    // right-hand label
    let maximumValueLabel: Text?
    // called with `true` when sliding starts and with `false` when it stops
    let onEditingChanged: ((Bool) -> Void)?
    // the track view
    let track: () -> Track
    // the fill view
    let fill: () -> Fill
    // the thumb view
    let thumb: () -> Thumb
    // tells how big the thumb is. This is here because there's no good
    // way in SwiftUI to get the thumb size at runtime, and its an important
    // to know it in order to compute its insets in the track overlay.
    let thumbSize: CGSize

    // x offset of the thumb from the track left-hand side
    @State private var xOffset: CGFloat = 0
    // last moved offset, used to decide if sliding has started
    @State private var lastOffset: CGFloat = 0
    // the size of the track view. This can be obtained at runtime.
    @State private var trackSize: CGSize = .zero

    /// Parameters:
    ///  - value: A Binding that will hold the selected value (Int, Float, Double, ...)
    ///  - in: (Optionnal) The range from which to pick values
    ///  - step: (Optionnal) The step at which to increment values
    ///  - minimumValueLabel: (Optionnal) A Text displayed to the left of the track
    ///  - maximumValueLabel: (Optionnal) A Text displayed to the right of the track
    ///  - onEditingChanged: (Optionnal) A method or closure property that does something when the value cahnges
    ///  - track: A shape representing the track on which the slider moves
    ///  - fill: A shape representing the left part of the track, between the start and the slider
    ///  - thumb: A shape representing the moving part of the slider
    ///  - thumbSize: CGSize representing the width and height of the thumb
    public init(value: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value = 0.001,
        minimumValueLabel: Text? = nil,
        maximumValueLabel: Text? = nil,
        onEditingChanged: ((Bool) -> Void)? = nil,
        track: @escaping () -> Track,
        fill: @escaping () -> Fill,
        thumb: @escaping () -> Thumb,
        thumbSize: CGSize) {
        _value = value
        self.bounds = bounds
        self.step = step
        self.minimumValueLabel = minimumValueLabel
        self.maximumValueLabel = maximumValueLabel
        self.onEditingChanged = onEditingChanged
        self.track = track
        self.fill = fill
        self.thumb = thumb
        self.thumbSize = thumbSize
    }

    // where does the current value sit, percentage-wise, in the provided bounds
    private var percentage: Value {
        1 - (bounds.upperBound - value) / (bounds.upperBound - bounds.lowerBound)
    }

    // how wide should the fill view be
    private var fillWidth: CGFloat {
        trackSize.width * CGFloat(percentage)
    }

    public var body: some View {
    // the HStack orders minimumValueLabel, the slider and maximumValueLabel horizontally
        HStack {
            minimumValueLabel.primaryFont(size: .L, weight: .medium)

            // Represent the custom slider. ZStack overlays `fill` on top of `track`,
            // while the `thumb` is in their `overlay`.
            ZStack(alignment: .leading) {
                track()
                // get the size of the track at runtime as it
                // defines all the other functionality
                .measureSize {
                    // if this is the first time trackSize is computed,
                    // update the offset to reflect the current `value`
                    let firstInit = (trackSize == .zero)
                    trackSize = $0
                    if firstInit {
                        xOffset = trackSize.width * CGFloat(percentage)
                        lastOffset = xOffset
                    }
                }
                fill()
                    // `fill` changes both its position and frame as its
                    // anchor point is in its middle
                    .position(x: fillWidth / 2, y: trackSize.height / 2)
                    .frame(width: fillWidth, height: trackSize.height)
            }
            // make sure the entire ZStack is the same size as `track`
            .frame(width: .infinity, height: trackSize.height)
            // the thumb lives in the ZStack overlay
            .overlay(thumb()
                // adjust the insets so that `thumb` doesn't sit outside the `track`
                .position(x: thumbSize.width / 2,
                          y: thumbSize.height / 2)
                // set the size here to make sure it's really the same as the
                // provided `thumbSize` parameter
                .frame(width: thumbSize.width, height: thumbSize.height)
                // set the offset to, well, the stored xOffset
                .offset(x: xOffset)
                // use the DragGesture to move the `thumb` around as adjust xOffset
                .gesture(DragGesture(minimumDistance: 0).onChanged({ gestureValue in
                    // make sure at least some dragging was done to trigger `onEditingChanged`
                    if abs(gestureValue.translation.width) < 0.1 {
                        lastOffset = xOffset
                        onEditingChanged?(true)
                    }
                    // update xOffset by the gesture translation, making sure it's within the view's bounds
                    let availableWidth = trackSize.width - thumbSize.width
                    xOffset = max(0, min(lastOffset + gestureValue.translation.width, availableWidth))
                    // update the value by mapping xOffset to the track width and then to the provided bounds
                    // also make sure that the value changes discretely based on the `step` para
                    let newValue = (bounds.upperBound - bounds.lowerBound) * Value(xOffset / availableWidth) + bounds.lowerBound
                    let steppedNewValue = (round(newValue / step) * step)
                    value = min(bounds.upperBound, max(bounds.lowerBound, steppedNewValue))
                }).onEnded({ _ in
                    // once the gesture ends, trigger `onEditingChanged` again
                    onEditingChanged?(false)
                })),
                alignment: .leading)

            maximumValueLabel.primaryFont(size: .L, weight: .medium)
        }
        // manually set the height of the entire view to account for thumb height
        .frame(height: max(trackSize.height, thumbSize.height))
    }
}

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero

  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}

struct MeasureSizeModifier: ViewModifier {
  func body(content: Content) -> some View {
    content.background(GeometryReader { geometry in
      Color.clear.preference(key: SizePreferenceKey.self,
                             value: geometry.size)
    })
  }
}

extension View {
  func measureSize(perform action: @escaping (CGSize) -> Void) -> some View {
    self.modifier(MeasureSizeModifier())
      .onPreferenceChange(SizePreferenceKey.self, perform: action)
  }
}

fileprivate struct CustomSliderPreviewContainer: View {
    private let thumbRadius: CGFloat = 30
    @State private var value = 50.0

    var body: some View {
        VStack {
            Text("Custom slider: \(value)")
            CustomSlider(value: $value,
                            in: 0...100,
                            step: 1,
                            minimumValueLabel: Text("Min"),
                            maximumValueLabel: Text("Max"),
                            onEditingChanged: { started in
                        print("started custom slider: \(started)")
            }, track: {
                Capsule()
                    .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                    .frame(width: 200, height: 5)
            }, fill: {
                Capsule()
                .foregroundColor(.blue)
            }, thumb: {
                Capsule()
                    .frame(width: thumbRadius, height: thumbRadius)
                    .foregroundColor(.white)
                    .shadow(radius: thumbRadius / 1)
            }, thumbSize: CGSize(width: thumbRadius, height: thumbRadius))
        }
    }
}

struct CustomSlider_Previews: PreviewProvider {
    static var previews: some View {
        CustomSliderPreviewContainer()
            .preferredColorScheme(.dark)
    }
}
