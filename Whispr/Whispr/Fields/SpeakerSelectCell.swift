//
//  SpeakerSelectCell.swift
//  Whispr
//
//  Created by Paul Erny on 03/07/2021.
//

import SwiftUI
import WhisprGenericViews

struct SpeakerSelectCell: View {
    private var label: String
    private var speakerImage: String
    private var action: (() -> ())
    @State private var isClicked: Bool = false
    @State private var isNavigationTriggered: Bool = false
    private var subLabel: String = ""
    private var subLabelColor: Color = .clear

    init(label: String, speakerImage: String, action: @escaping (() -> ()), isConnected: Bool = true) {
        self.label = label
        self.speakerImage = speakerImage
        self.action = action
        self.subLabel = isConnected ? "Connected" : "Offline"
        self.subLabelColor = isConnected ? .LED : .error
    }

    var body: some View {
        NavigationLink(destination: SpeakerView(speakerName: label), isActive: $isNavigationTriggered) {
            ButtonCell(label: label,
                       subLabel: subLabel,
                       action: {
                        isClicked.toggle()
                        action()
                        isNavigationTriggered = true
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                            isClicked.toggle()
                        }
                       },
                       leftView: {
                        Image(speakerImage)
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                       },
                       rightView: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(isClicked ? .success : .primaryText)
                            .primaryFont(size: .XL, weight: .medium)
                       })
                .primaryColor(Color.primaryText)
                .secondaryColor(subLabelColor)
                .clickedColor(Color.success)
        }
    }
}

struct SpeakerSelectCell_Previews: PreviewProvider {
    static var previews: some View {
        
        let action = {
            print("pressed")
        }
        NavigationView {
            SpeakerSelectCell(label: "test", speakerImage: "portable2", action: action)
                .navigationTitle("Navigation")
                .preferredColorScheme(.dark)
        }
    }
}
