//
//  SpeakerView.swift
//  Whispr
//
//  Created by Paul Erny on 15/10/2021.
//

import SwiftUI
//import WhisprGenericViews

struct SpeakerView: View {
    var speakerName: String
    private var speaker: Speaker
    @State var tmpSpeakerName: String
    @State var volumeValue: CGFloat = 32
    var onVolumeChanged: ((Bool) -> ()) = {_ in }
    @State var noiseCancelingValue: CGFloat = 74
    var onNoiseCancelingChanged: ((Bool) -> ()) = {_ in }
    @EnvironmentObject var contentManager: ContentManager

    init(speaker: Speaker) {
        self.speaker = speaker
        self.speakerName = speaker.name
        self.tmpSpeakerName = speaker.name
    }
    
    var body: some View {
        ListView(sections: [
            Section(items: [
                AnyView(TextFieldCell(text: $tmpSpeakerName, label: "Name", placeholder: "My speaker")),
                AnyView(SliderCell(value: $volumeValue, onValueChanged: onVolumeChanged, label: "Volume")),
                AnyView(SliderCell(value: $noiseCancelingValue, onValueChanged: onNoiseCancelingChanged, label: "Noise canceling")),
            ]),
            Section(items:
                        { () -> [AnyView] in
                            var configViews: [AnyView] = []
                            for item in speaker.configs {
                                print("config: " + item.name)
                                configViews.append(AnyView(
                                    SpeakerConfigButtonCell(
                                        
                                        configName: item.name,
                                        isActive: true
                                    )
                                    .environmentObject(contentManager)
                                ))
                            }
                            print("main " + String(configViews.count))
                            configViews.append(
                                AnyView(AddConfigCell(speakerId: speaker.id, action: {})
                                            .environmentObject(contentManager)
                                )
                            )
                            return configViews
                        }(),
            header: "Configurations"),
            Section(items: [
                AnyView(DeleteCell(action: {
                    contentManager.delete(id: speaker.id)
                }))
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
            SpeakerView(speaker: Speaker(name: "my speaker", volume: 50, noiseCanceling: 50))
                .preferredColorScheme(.dark)
        }
    }
}
