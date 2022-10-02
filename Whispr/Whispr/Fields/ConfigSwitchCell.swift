//
//  ConfigSwitchCell.swift
//  Whispr
//
//  Created by Paul Erny on 13/01/2022.
//

import SwiftUI
import WhisprGenericViews

struct ConfigSwitchCell: View {
    @Binding var hasPeriodicActivation: Bool
    var onValueChanged: ((Bool) -> ())
    
    init(state hasPeriodicActivation: Binding<Bool>,
         onValueChanged: @escaping ((Bool) -> ())) {
        self._hasPeriodicActivation = hasPeriodicActivation
        self.onValueChanged = onValueChanged
    }
    
    var body: some View {
        SwitchCell(label: Strings.periodicity, value: $hasPeriodicActivation, onValueChanged: onValueChanged)
            .primaryColor(Color.yellow)
    }
}

private struct Strings {
    static let periodicity = NSLocalizedString("Activation Périodique", comment: "Fields / ConfigSwitchCell / periodicity")
}

struct ConfigSwitchCellPreviewContainer: View {
    @State var hasPeriodicActivation: Bool = false

    var body: some View {
        ConfigSwitchCell(state: $hasPeriodicActivation, onValueChanged: {_ in})
    }
}

struct ConfigSwitchCell_Previews: PreviewProvider {
    static var previews: some View {
        ConfigSwitchCellPreviewContainer()
    }
}
