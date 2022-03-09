//
//  AddConfigView.swift
//  Whispr
//
//  Created by Paul Erny on 04/12/2021.
//

import SwiftUI
import WhisprGenericViews

/// Speaker configuration creation page
///
/// Displayed when clicking on the "AddConfigCell" button from the SpeakerView. This view is composed of
/// the name and settings of the configuration to create.
struct AddConfigView: View {
    private var speakerId: UUID
    @State var configName: String = ""
    @State var volumeValue: CGFloat = 50
    @State var noiseCancelingValue: CGFloat = 50
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var contentManager: ContentManager
    @State var startTime = Calendar.autoupdatingCurrent.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
    @State var endTime = Calendar.autoupdatingCurrent.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
    @State var hasPeriodicActivation: Bool = false
    
    @State private var timeTriggerFields: [AnyView] = []
    @State private var timeTriggerSection: [AnyView] = []
    
    private var newConfig = SpeakerConfig()
    
    init(speakerId: UUID) {
        self.speakerId = speakerId
    }
    
    func toggleTimeTrigger(newValue: Bool) {
        if (newValue && timeTriggerSection.count < 3) {
            timeTriggerSection.append(contentsOf: timeTriggerFields)
        } else if (!newValue && timeTriggerSection.count > 1) {
            timeTriggerSection.removeLast(2)
        }
        newConfig.hasTimeTrigger = newValue
    }
    
    func onNameChanged(value: String) {
        newConfig.name = value
    }
    
    func onVolumeChanged(value: Bool) {
        newConfig.volume = Double(volumeValue)
    }
    
    func onNoiseCancelingChanged(value: Bool) {
        newConfig.noiseCanceling = Double(noiseCancelingValue)
    }
    
    func onStartTimeChanged(value: Date) {
        newConfig.startTime = value
    }
    
    func onEndTimeChanged(value: Date) {
        newConfig.endTime = value
    }
    
    var body: some View {
        ListView(sections: [
            Section(items: [
                AnyView(TextFieldCell(text: $configName, label: "Name", placeholder: "My configuration", onEditingChange: onNameChanged)),
                AnyView(SliderCell(value: $volumeValue, onValueChanged: onVolumeChanged, label: "Volume")
                            .secondaryColor(.whisprYellow)),
                AnyView(SliderCell(value: $noiseCancelingValue, onValueChanged: onNoiseCancelingChanged, label: "Noise canceling")
                            .secondaryColor(.whisprYellow))
            ]),
            Section(items: timeTriggerSection,
                    header: "Time trigger", footer: "If activated, triggers this configuration on the connected speaker(s) between the specified time period."),
            Section(items: [
                AnyView(SaveCell(action: {
                    if !configName.isEmpty {
                        contentManager.add(config:
                                            newConfig,
                                           speakerId: speakerId)
                        self.mode.wrappedValue.dismiss()
                    }
                }))
            ])
        ], style: .plain)
        .onAppear(perform: {
            self.timeTriggerFields = [
                AnyView(DatePickerCell(date: $startTime, label: "Activation", onValueChange: onStartTimeChanged)),
                AnyView(DatePickerCell(date: $endTime, label: "Deactivation", onValueChange: onEndTimeChanged))
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
