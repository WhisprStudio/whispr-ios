//
//  SpeakerSelectCell.swift
//  Whispr
//
//  Created by Paul Erny on 03/07/2021.
//

import SwiftUI
//import WhisprGenericViews

struct SpeakerSelectCell: View {
    private var speaker: Speaker
    private var action: (() -> ())
    @State private var speakerName: String
    @State private var isClicked: Bool = false
    @State private var isNavigationTriggered: Bool = false
    private var subLabel: String = ""
    private var subLabelColor: Color = .clear
    @EnvironmentObject var contentManager: ContentManager

    init(speaker: Speaker, action: @escaping (() -> ()), isConnected: Bool = true) {
        self.speaker = speaker
        self.action = action
        self.subLabel = isConnected ? "Connected" : "Offline"
        self.subLabelColor = isConnected ? .LED : .error
        self.speakerName = speaker.name
    }

    var body: some View {
        NavigationLink(destination: SpeakerView(speaker: speaker)
                        .environmentObject(contentManager),
                       isActive: $isNavigationTriggered) {
            ButtonCell(label: speakerName,
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
                        Image(speaker.type)
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
        .isDetailLink(false)
//        .onDisappear(perform: {
//            isNavigationTriggered = false
//        })
    }
}

struct SpeakerSelectCell_Previews: PreviewProvider {
    static var previews: some View {
        
        let action = {
            print("pressed")
        }
        let contentManager = ContentManager()
        NavigationView {
            SpeakerSelectCell(speaker: Speaker(name: "speaker", volume: 50, noiseCanceling: 50), action: action)
                .environmentObject(contentManager)
                .navigationTitle("Navigation")
                .preferredColorScheme(.dark)
        }
    }
}
