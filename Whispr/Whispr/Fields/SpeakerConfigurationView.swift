//
//  SpeakerConfigurationView.swift
//  Whispr
//
//  Created by Paul Erny on 05/11/2021.
//

//import WhisprGenericViews
import SwiftUI

struct SpeakerConfigurationView: View {
    @State var configName: String
    
//    @State var tmpConfigName: String
    @State var volumeValue: CGFloat = 50
    var config: SpeakerConfig
    var speakerId: UUID
    var onVolumeChanged: ((Bool) -> ()) = {_ in }
    @State var noiseCancelingValue: CGFloat = 50
    var onNoiseCancelingChanged: ((Bool) -> ()) = {_ in }
    @EnvironmentObject var contentManager: ContentManager
    
    init(config: SpeakerConfig, speakerId: UUID) {
        self.config = config
        self.speakerId = speakerId
        _configName = State(initialValue: config.name)
//        self.tmpConfigName = config.name
    }
    
    var body: some View {
        ListView(sections: [
            Section(items: [
                AnyView(TextFieldCell(text: $configName, label: "Name", placeholder: "My configuration")),
                AnyView(SliderCell(value: $volumeValue, onValueChanged: onVolumeChanged, label: "Volume")),
                AnyView(SliderCell(value: $noiseCancelingValue, onValueChanged: onNoiseCancelingChanged, label: "Noise canceling"))
            ]),
            Section(items: [
                AnyView(Text("Time trigger")),
                AnyView(Text("Bigining hour")),
                AnyView(Text("Ending hour"))
            ], header: "Time trigger", footer: "If activated, triggers this configuration on the connected speaker(s) between the specified time period."),
            Section(items: [
                AnyView(DeleteCell(action: {
                    contentManager.delete(configId: config.id, speakerId: speakerId)
                }))
            ])
        ], style: .plain)
        .separatorColor(Color.separator)
        .primaryColor(Color.primaryText)
        .backgroundColor(Color.fieldBackground)
        .navigationTitle(config.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(NavigationConfigurator())
    }
}

struct SpeakerConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        let contentManager = ContentManager()

        NavigationView {
            SpeakerConfigurationView(config: SpeakerConfig(name: "home", volume: 50, noiseCanceling: 50), speakerId: UUID())
                .environmentObject(contentManager)
                .preferredColorScheme(.dark)
        }
    }
}
