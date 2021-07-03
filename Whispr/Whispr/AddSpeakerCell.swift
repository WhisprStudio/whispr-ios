//
//  AddSpeakerCell.swift
//  Whispr
//
//  Created by Paul Erny on 03/07/2021.
//

import SwiftUI

struct AddSpeakerCell: View {
    private var action: (() -> ())
    
    init(action: @escaping (() -> ())) {
        self.action = action
    }

    var body: some View {
        ButtonCell(label: "Nouvelle enceinte",
                   action: action,
                   rightView: {
                    HStack {
                        Image(systemName: "plus")
                            .primaryFont(size: .XL, weight: .medium)
                    }
                   })
    }
}

struct AddSpeakerCell_Previews: PreviewProvider {
    static var previews: some View {
        AddSpeakerCell(action: {})
            .preferredColorScheme(.dark)
    }
}
