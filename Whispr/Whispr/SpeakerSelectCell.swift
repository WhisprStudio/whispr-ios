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
        Button(action: action) {
            HStack {
                Image(speakerImage)
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                Spacer()
                Text(label)
                    .foregroundColor(.primaryText)
                    .primaryFont(size: .L, weight: .medium)
                    .padding(.trailing)
                Image(systemName: "chevron.right")
                    .primaryFont(size: .XL, weight: .medium)
            }
        }
        .frame(minWidth: 0, maxWidth: 350 )
        .padding()
        .foregroundColor(.primaryText)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.primaryText, lineWidth: 2)
        )
        .background(Color.background)
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
