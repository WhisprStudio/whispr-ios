//
//  SpeakerView.swift
//  Whispr
//
//  Created by Paul Erny on 15/10/2021.
//

import SwiftUI
import WhisprGenericViews

struct SpeakerView: View {
    var speakerName: String
    
    @State var tmpSpeakerName: String
    @State var volumeValue: CGFloat = 32
    var onVolumeChanged: ((Bool) -> ()) = {_ in }
    @State var noiseCancelingValue: CGFloat = 74
    var onNoiseCancelingChanged: ((Bool) -> ()) = {_ in }

    init(speakerName: String) {
        self.speakerName = speakerName
        self.tmpSpeakerName = speakerName
    }
    
    var body: some View {
        ListView(sections: [
            Section(items: [
                AnyView(TextFieldCell(text: $tmpSpeakerName, label: "Name", placeholder: "My speaker")),
                AnyView(SliderCell(value: $volumeValue, onValueChanged: onVolumeChanged, label: "Volume")),
                AnyView(SliderCell(value: $noiseCancelingValue, onValueChanged: onNoiseCancelingChanged, label: "Noise canceling")),
            ]),
            Section(items: [
                AnyView(SpeakerConfigButtonCell(configName: "Home",
                                                isActive: true)),
                AnyView(SpeakerConfigButtonCell(configName: "Sleep",
                                                isActive: false)),
                AnyView(SpeakerConfigButtonCell(configName: "Outside",
                                                isActive: false)),
                AnyView(AddConfigCell(action: {}))
            ], header: "Configurations"),
            Section(items: [
                AnyView(DeleteCell(action: {}))
            ])
        ], style: .plain)
        .separatorColor(Color.separator)
        .primaryColor(Color.primaryText)
        .backgroundColor(Color.fieldBackground)
        .navigationTitle(speakerName)
        .navigationBarTitleDisplayMode(.inline)
        .background(NavigationConfigurator())
    }
}

struct SpeakerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SpeakerView(speakerName: "my speaker")
                .preferredColorScheme(.dark)
        }
    }
}
