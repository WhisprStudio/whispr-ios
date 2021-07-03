//
//  SpeakerSelectCell.swift
//  Whispr
//
//  Created by Paul Erny on 03/07/2021.
//

import SwiftUI

struct SpeakerSelectCell: View {
    private var label: String
    private var speakerImage: String
    private var action: (() -> ())
    
    init(label: String, speakerImage: String, action: @escaping (() -> ())) {
        self.label = label
        self.speakerImage = speakerImage
        self.action = action
    }

    var body: some View {
        ButtonCell(label: label,
                   action: action,
                   leftView: {
                    Image(speakerImage)
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                   },
                   rightView: {
                    Image(systemName: "chevron.right")
                        .primaryFont(size: .XL, weight: .medium)
                   })
    }
}

struct SpeakerSelectCell_Previews: PreviewProvider {
    static var previews: some View {
        
        let action = {
            print("pressed")
        }
        
        SpeakerSelectCell(label: "test", speakerImage: "portable2", action: action)
            .preferredColorScheme(.dark)
    }
}
