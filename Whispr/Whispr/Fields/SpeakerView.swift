//
//  SpeakerView.swift
//  Whispr
//
//  Created by Paul Erny on 15/10/2021.
//

import SwiftUI
import WhisprGenericViews

struct SpeakerView: View {
    private var speaker: Speaker
    @State var speakerName: String
    @State var volumeValue: CGFloat
    @State var noiseCancelingValue: CGFloat
    @EnvironmentObject var contentManager: ContentManager

    init(speaker: Speaker) {
        self.speaker = speaker
        self.speakerName = speaker.name
        self.volumeValue = CGFloat(speaker.volume)
        self.noiseCancelingValue = CGFloat(speaker.noiseCanceling)
    }
    
    func onNameChange(value: String) {
        contentManager.save(property: .name, value: value, speakerId: speaker.id)
    }
    
    func onVolumeChanged(value: Bool) {
        contentManager.save(property: .volume, value: volumeValue.description, speakerId: speaker.id)
    }
    
    func onNoiseCancelingChanged(value: Bool) {
        contentManager.save(property: .noiseCanceling, value: noiseCancelingValue.description, speakerId: speaker.id)
    }

    var body: some View {
        ListView(sections: [
            Section(items: [
                AnyView(TextFieldCell(text: $speakerName, label: "Name", placeholder: "My speaker", onEditingChange: self.onNameChange)),
                AnyView(SliderCell(value: $volumeValue, onValueChanged: onVolumeChanged, label: "Volume")
                            .secondaryColor(.whisprYellow)),
                AnyView(SliderCell(value: $noiseCancelingValue, onValueChanged: onNoiseCancelingChanged, label: "Noise canceling")
                            .secondaryColor(.whisprYellow)),
            ]),
            Section(items:
                        { () -> [AnyView] in
                            var configViews: [AnyView] = []
                            for (index, item) in speaker.configs.enumerated() {
                                let isActive = index == 0 ? true : false
                                configViews.append(AnyView(
                                    SpeakerConfigButtonCell(
                                        config: item,
                                        speakerId: speaker.id,
                                        isActive: isActive
                                    )
                                    .environmentObject(contentManager)
                                ))
                            }
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
        let contentManager = ContentManager()
        NavigationView {
            SpeakerView(speaker: Speaker(name: "my speaker", volume: 50, noiseCanceling: 50))
                .environmentObject(contentManager)
                .preferredColorScheme(.dark)
        }
    }
}
