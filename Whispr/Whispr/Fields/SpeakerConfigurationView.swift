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
    @State var startTime = Calendar.autoupdatingCurrent.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
    @State var endTime = Calendar.autoupdatingCurrent.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
    @State var hasPeriodicActivation: Bool = false
    
    @State private var timeTriggerFields: [AnyView] = []
    @State private var timeTriggerSection: [AnyView] = []
    
    init(config: SpeakerConfig, speakerId: UUID) {
        self.config = config
        self.speakerId = speakerId
        _configName = State(initialValue: config.name)
    }

    func toggleTimeTrigger(newValue: Bool) {
        if (newValue && timeTriggerSection.count < 3) {
            timeTriggerSection.append(contentsOf: timeTriggerFields)
        } else if (!newValue && timeTriggerSection.count > 1) {
            timeTriggerSection.removeLast(2)
        }
    }

    var body: some View {
        ListView(sections: [
            Section(items: [
                AnyView(TextFieldCell(text: $configName, label: "Name", placeholder: "My configuration")),
                AnyView(SliderCell(value: $volumeValue, onValueChanged: onVolumeChanged, label: "Volume")),
                AnyView(SliderCell(value: $noiseCancelingValue, onValueChanged: onNoiseCancelingChanged, label: "Noise canceling"))
            ]),
            Section(items: timeTriggerSection,
                    header: "Time trigger", footer: "If activated, triggers this configuration on the connected speaker(s) between the specified time period."),
            Section(items: [
                AnyView(DeleteCell(action: {
                    contentManager.delete(configId: config.id, speakerId: speakerId)
                }))
            ])
        ], style: .plain)
        .onAppear(perform: {
            self.timeTriggerFields = [
                AnyView(DatePickerCell(date: $startTime, label: "Activation")),
                AnyView(DatePickerCell(date: $endTime, label: "Deactivation"))
            ]
            self.timeTriggerSection = [
                AnyView(ConfigSwitchCell(state: $hasPeriodicActivation, onValueChanged: toggleTimeTrigger))
            ]
            if (hasPeriodicActivation) {
                timeTriggerSection.append(contentsOf: timeTriggerFields)
            }
        })
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
