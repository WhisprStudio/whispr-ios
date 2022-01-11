//
//  DeleteCell.swift
//  
//
//  Created by Paul Erny on 09/10/2021.
//

import SwiftUI

public struct DeleteCell: View {
    private var action: (() -> ())
    
    @Environment(\.deleteTextColor) var deleteTextColor : Color
    
    public init(action: @escaping (() -> ())) {
        self.action = action
    }
    
    public var body: some View {
        if deleteTextColor != .primary {
            ButtonCell(label: "Supprimer", action: action)
                .padding(.leading)
                .primaryColor(deleteTextColor)
        } else {
            ButtonCell(label: "Supprimer", action: action)
                .padding(.leading)
                .primaryColor(.red)
        }
    }
}

struct DeleteCell_Previews: PreviewProvider {
    static var previews: some View {
        DeleteCell(action: {})
            .preferredColorScheme(.dark)
    }
}
