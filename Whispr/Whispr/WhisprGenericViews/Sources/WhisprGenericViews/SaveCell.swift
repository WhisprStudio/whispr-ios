//
//  SaveCell.swift
//  
//
//  Created by Paul Erny on 09/10/2021.
//

import SwiftUI

public struct SaveCell: View {
    private var action: (() -> ())
    
    @Environment(\.saveTextColor) var saveTextColor : Color
    
    public init(action: @escaping (() -> ())) {
        self.action = action
    }
    
    public var body: some View {
        if saveTextColor != .primary {
            ButtonCell(label: "Enregister", action: action)
                .padding(.leading)
                .primaryColor(saveTextColor)
        } else {
            ButtonCell(label: "Enregister", action: action)
                .padding(.leading)
                .primaryColor(.blue)
        }
    }
}

struct SaveCell_Previews: PreviewProvider {
    static var previews: some View {
        SaveCell(action: {})
            .preferredColorScheme(.dark)
    }
}
