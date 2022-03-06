//
//  DatePickerCell.swift
//  Whispr
//
//  Created by Paul Erny on 13/01/2022.
//

import SwiftUI

public struct DatePickerCell: View {
    @Binding var date: Date
    var label: String
    var onValueChange: (Date)->()

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
