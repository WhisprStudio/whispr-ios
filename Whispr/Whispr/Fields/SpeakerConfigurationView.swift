//
//  SpeakerConfigurationView.swift
//  Whispr
//
//  Created by Paul Erny on 05/11/2021.
//

import WhisprGenericViews
import SwiftUI

/// Speaker configuration page
///
/// Displayed when clicking on a configuration from the SpeakerView page.
/// This view shows the name, preset volume and noise canceling and other settings of the current configuration.
struct SpeakerConfigurationView: View {
    @State var configName: String

    @State var volumeValue: CGFloat
    var config: SpeakerConfig
    var speakerId: UUID
    @State var noiseCancelingValue: CGFloat
    @EnvironmentObject var contentManager: ContentManager
    @State var startTime: Date
    @State var endTime: Date
    @State var hasPeriodicActivation: Bool
    @State private var timeTriggerFields: [AnyView] = []
    @State private var timeTriggerSection: [AnyView] = []

    init(config: SpeakerConfig, speakerId: UUID) {
        self.config = config
        self.speakerId = speakerId
        self._volumeValue = State(initialValue: CGFloat(config.volume))
        self._noiseCancelingValue = State(initialValue: CGFloat(config.noiseCanceling))
        self._configName = State(initialValue: config.name)
        self._startTime = State(initialValue: config.startTime)
        self._endTime = State(initialValue: config.endTime)
        self._hasPeriodicActivation = State(initialValue: config.hasTimeTrigger)
    }

    func onNameChange(value: String) {
        contentManager.saveConfig(property: .name, value: value, speakerId: speakerId, configId: config.id)
    }
    
    func onVolumeChanged(value: Bool) {
        contentManager.saveConfig(property: .volume, value: volumeValue.description, speakerId: speakerId, configId: config.id)
    }
    
    func onNoiseCancelingChanged(value: Bool) {
        contentManager.saveConfig(property: .noiseCanceling, value: noiseCancelingValue.description, speakerId: speakerId, configId: config.id)
    }
    
    func onStartTimeChanged(value: Date) {
        contentManager.saveConfig(property: .startTime, value: startTime.timeIntervalSince1970.description, speakerId: speakerId, configId: config.id)
    }
    
    func onEndTimeChanged(value: Date) {
        contentManager.saveConfig(property: .endTime, value: endTime.timeIntervalSince1970.description, speakerId: speakerId, configId: config.id)
    }

    func toggleTimeTrigger(newValue: Bool) {
        if (newValue && timeTriggerSection.count < 3) {
            timeTriggerSection.append(contentsOf: timeTriggerFields)
        } else if (!newValue && timeTriggerSection.count > 1) {
            timeTriggerSection.removeLast(2)
        }
        contentManager.saveConfig(property: .timeTrigger, value: newValue.description, speakerId: speakerId, configId: config.id)
    }

    var body: some View {
        ListView(sections: [
            Section(items: [
                AnyView(TextFieldCell(text: $configName, label: Strings.nameLabel, placeholder: Strings.namePlaceholder, onEditingChange: self.onNameChange)),
                AnyView(SliderCell(value: $volumeValue, onValueChanged: onVolumeChanged, label: Strings.volumeLabel)
                            .secondaryColor(.whisprYellow)),
                AnyView(SliderCell(value: $noiseCancelingValue, onValueChanged: onNoiseCancelingChanged, label: Strings.noiseCancelingLabel)
                            .secondaryColor(.whisprYellow))
            ]),
            Section(items: timeTriggerSection,
                    header: Strings.timeTriggerHeader, footer: Strings.timeTriggerFooter),
            Section(items: [
                AnyView(DeleteCell(action: {
                    contentManager.delete(configId: config.id, speakerId: speakerId)
                }))
            ])
        ], style: .plain)
        .onAppear(perform: {
            self.timeTriggerFields = [
                AnyView(DatePickerCell(date: $startTime, label: Strings.startTimeLabel, onValueChange: onStartTimeChanged)),
                AnyView(DatePickerCell(date: $endTime, label: Strings.endTimeLabel, onValueChange: onEndTimeChanged))
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
        .navigationTitle(configName)
        .navigationBarTitleDisplayMode(.inline)
        .background(NavigationConfigurator())
    }
}

private struct Strings {
    static let nameLabel = NSLocalizedString("Nom", comment: "Views / AddConfigView / name cell label")
    static let namePlaceholder = NSLocalizedString("Ma config", comment: "Views / AddConfigView / name cell placeholder")
    static let volumeLabel = NSLocalizedString("Volume", comment: "Views / AddConfigView / volume cell label")
    static let noiseCancelingLabel = NSLocalizedString("Reduction du bruit", comment: "Views / AddConfigView / noise canceling cell placeholder")
    static let title = NSLocalizedString("Nouvelle configurations", comment: "Views / AddConfigView / config section header")
    
    static let timeTriggerHeader = NSLocalizedString("Répétition", comment: "Views / AddConfigView / time trigger header")
    static let timeTriggerFooter = NSLocalizedString("Si activé, la configuration s'activera automatiquement pendant les heures choisies", comment: "Views / AddConfigView / time trigger footer")
    
    static let startTimeLabel = NSLocalizedString("Activation", comment: "Views / AddConfigView / start time")
    static let endTimeLabel = NSLocalizedString("Jusqu'a", comment: "Views / AddConfigView / end time")
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
