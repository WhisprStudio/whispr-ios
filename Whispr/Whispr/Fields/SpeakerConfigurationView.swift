//
//  SpeakerConfigurationView.swift
//  Whispr
//
//  Created by Paul Erny on 05/11/2021.
//

import WhisprGenericViews
import SwiftUI

struct SpeakerConfigurationView: View {
    var configName: String
    
    @State var tmpConfigName: String
    @State var volumeValue: CGFloat = 50
    var onVolumeChanged: ((Bool) -> ()) = {_ in }
    @State var noiseCancelingValue: CGFloat = 50
    var onNoiseCancelingChanged: ((Bool) -> ()) = {_ in }
    
    init(configName: String) {
        self.configName = configName
        self.tmpConfigName = configName
    }
    
    var body: some View {
        ListView(sections: [
            Section(items: [
                AnyView(TextFieldCell(text: $tmpConfigName, label: "Name", placeholder: "My configuration")),
                AnyView(SliderCell(value: $volumeValue, onValueChanged: onVolumeChanged, label: "Volume")),
                AnyView(SliderCell(value: $noiseCancelingValue, onValueChanged: onNoiseCancelingChanged, label: "Noise canceling"))
            ]),
            Section(items: [
                AnyView(Text("Time trigger")),
                AnyView(Text("Bigining hour")),
                AnyView(Text("Ending hour"))
            ], header: "Time trigger", footer: "If activated, triggers this configuration on the connected speaker(s) between the specified time period."),
            Section(items: [
                AnyView(DeleteCell(action: {}))
            ])
        ], style: .plain)
        .separatorColor(Color.separator)
        .primaryColor(Color.primaryText)
        .backgroundColor(Color.fieldBackground)
        .navigationTitle(configName)
        .navigationBarTitleDisplayMode(.inline)
        .background(NavigationConfigurator())
    }
}

struct SpeakerConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SpeakerConfigurationView(configName: "test")
                .preferredColorScheme(.dark)
        }
    }
}
