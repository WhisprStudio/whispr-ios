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
    @State var startTime = Calendar.autoupdatingCurrent.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
    @State var endTime = Calendar.autoupdatingCurrent.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
    @State var hasPeriodicActivation: Bool = false
    
    @State private var timeTriggerFields: [AnyView] = []
    @State private var timeTriggerSection: [AnyView] = []
    
    init(speakerId: UUID) {
        self.speakerId = speakerId
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
