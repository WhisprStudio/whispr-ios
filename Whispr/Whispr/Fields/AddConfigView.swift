//
//  AddConfigView.swift
//  Whispr
//
//  Created by Paul Erny on 04/12/2021.
//

import SwiftUI
//import WhisprGenericViews

struct AddConfigView: View {
    private var speakerId: UUID
    @State var configName: String = ""
    @State var volumeValue: CGFloat = 50
    var onVolumeChanged: ((Bool) -> ()) = {_ in }
    @State var noiseCancelingValue: CGFloat = 50
    var onNoiseCancelingChanged: ((Bool) -> ()) = {_ in }
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var contentManager: ContentManager
    
    init(speakerId: UUID) {
        self.speakerId = speakerId
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
                AnyView(SaveCell(action: {
                    if !configName.isEmpty {
                        contentManager.add(config:
                                            SpeakerConfig(name: configName,
                                                          volume: Double(volumeValue),
                                                          noiseCanceling: Double(noiseCancelingValue)),
                                           speakerId: speakerId)
                        self.mode.wrappedValue.dismiss()
                    }
                }))
            ])
        ], style: .plain)
        .separatorColor(Color.separator)
        .primaryColor(Color.primaryText)
        .backgroundColor(Color.fieldBackground)
        .navigationTitle("Add configuration")
        .navigationBarTitleDisplayMode(.inline)
        .background(NavigationConfigurator())
    }
}

struct AddConfigView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddConfigView(speakerId: UUID())
        }
        .preferredColorScheme(.dark)
    }
}
