//
//  DatePickerCell.swift
//  Whispr
//
//  Created by Paul Erny on 13/01/2022.
//

import SwiftUI

/// A control for selecting a timestamp (Hour and minutes).
///
/// You create a DatePickerCell by providing a binding in which to store the date in, a label and an action.
/// The action is either a method or closure property that gets called when the selected date changes.
/// The label is a string that describes the button's action.
///
/// ### Implementation
///
/// ```swift
///     DatePickerCell(date: $date, label: "Add Alarm", onValueChange: saveValue)
/// ```
///
/// Parameter:
/// - label: A String or LocalizedStringKey representing the text displayed left of the time picker
/// - onValueChange: method or closure property that gets called when the selected date changes
/// - `date`: A Binding of type Date
public struct DatePickerCell: View {
    @Binding var date: Date
    var label: String
    var onValueChange: (Date)->()

    /// Default initialiser
    /// 
    /// Parameter:
    /// - label: A String or LocalizedStringKey representing the text displayed left of the time picker
    /// - onValueChange: method or closure property that gets called when the selected date changes
    /// - `date`: A Binding of type Date
    public init(date: Binding<Date>,
                label: String = "",
                onValueChange: @escaping (Date)->() = {_ in}) {
        self._date = date
        self.label = label
        self.onValueChange = onValueChange
    }

    public var body: some View {
        DatePicker(label, selection: $date, displayedComponents: .hourAndMinute)
//            .datePickerStyle(WheelDatePickerStyle())
            .onChange(of: date) {
                self.onValueChange($0)
            }
            .accentColor(.whisprYellow)
            .primaryFont(size: .L, weight: .medium)
    }
}

struct DatePickerPreviewContainer: View {
    @State var date = Date()
    var label = "label"

    var body: some View {
        DatePickerCell(date: $date, label: label, onValueChange: {_ in})
    }
}

struct DatePickerCell_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerPreviewContainer()
    }
}
