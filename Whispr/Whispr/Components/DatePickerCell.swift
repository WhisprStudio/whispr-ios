//
//  DatePickerCell.swift
//  Whispr
//
//  Created by Paul Erny on 13/01/2022.
//

import SwiftUI

struct DatePickerCell: View {
    @Binding var date: Date
    var label: String

    public init(date: Binding<Date>,
                label: String = "") {
        self._date = date
        self.label = label
    }

    var body: some View {
        DatePicker(label, selection: $date, displayedComponents: .hourAndMinute)
//            .datePickerStyle(WheelDatePickerStyle())
            .accentColor(.whisprYellow)
            .primaryFont(size: .L, weight: .medium)
    }
}

struct DatePickerPreviewContainer: View {
    @State var date = Date()
    var label = "label"

    var body: some View {
        DatePickerCell(date: $date, label: label)
    }
}

struct DatePickerCell_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerPreviewContainer()
    }
}
