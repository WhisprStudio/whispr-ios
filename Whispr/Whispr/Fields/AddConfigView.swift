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
        ZStack {
            ListView(sections: [
                Section(items: [
                    AnyView(TextFieldCell(text: $configName, label: Strings.nameLabel, placeholder: Strings.namePlaceholder, onEditingChange: onNameChanged)),
                    AnyView(SliderCell(value: $volumeValue, onValueChanged: onVolumeChanged, label: Strings.volumeLabel)
                                .secondaryColor(.whisprYellow)),
                    AnyView(SliderCell(value: $noiseCancelingValue, onValueChanged: onNoiseCancelingChanged, label: Strings.noiseCancelingLabel)
                                .secondaryColor(.whisprYellow))
                ]),
                Section(items: timeTriggerSection,
                        header: Strings.timeTriggerHeader, footer: Strings.timeTriggerFooter),
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
            .navigationTitle(Strings.title)
            .navigationBarTitleDisplayMode(.inline)
            .background(NavigationConfigurator())

            // -------- TUTORIAL VIEW --------
            // step 7 and 8
            if contentManager.tutorialStep == 7 ||
            contentManager.tutorialStep == 8 {
                TutoFour()
                    .environmentObject(contentManager)
            }
        }
    }
}

struct TutoFour: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var contentManager: ContentManager
    @State var makeTutoAppear = false
    @State var makeTutoDisappear = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: .infinity, height: 408)
                    .opacity(makeTutoDisappear ? 0 : (colorScheme == .dark ? 0.7 : 0.9))
                HighlightedText(text: Strings.tutoOne, highlighted: Strings.highlightsTutoOne, color: .whisprYellow)
                    .primaryFont(size: .L, weight: .medium)
                    .padding(.top, 120)
                    .offset(x: makeTutoAppear && contentManager.tutorialStep == 7 ? 0 : -380)
                    .opacity(makeTutoAppear && contentManager.tutorialStep == 7 ? 1 : 0)
                HighlightedText(text: Strings.tutoTwo, highlighted: Strings.highlightsTutoTwo, color: .whisprYellow)
                    .foregroundColor(Color.TutorialText)
                    .primaryFont(size: .L, weight: .medium)
                    .padding(10)
                    .padding(.top, 120)
                    .offset(x: contentManager.tutorialStep == 8 ? 0 : 355)
                    .opacity(makeTutoDisappear ? 0 : 1)
            }
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: 72)
                .opacity(makeTutoDisappear ? 0 : (colorScheme == .dark ? 0.7 : 0.9))
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: .infinity)
                .opacity(makeTutoDisappear ? 0 : (colorScheme == .dark ? 0.7 : 0.9))
        }
        .onTapGesture {
            if contentManager.tutorialStep == 7 {
                withAnimation(Animation.linear(duration: 0.2)) {
                    // go to step 8
                    contentManager.saveTutorial()
                }
            } else if contentManager.tutorialStep == 8 {
                withAnimation(Animation.linear(duration: 0.2)) {
                    // remove tutorial / step 9
                    makeTutoDisappear.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        contentManager.saveTutorial()
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                if !makeTutoAppear {
                    withAnimation(Animation.easeOut(duration: 0.2)) {
                        makeTutoAppear.toggle()
                    }
                }
            }
        }
        .ignoresSafeArea()
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

    static let tutoOne = NSLocalizedString("Les configurations permettent de modifier automatiquement les réglages de votre enceinte", comment: "Views / AddConfigView / tuto 1")
    static let highlightsTutoOne = [NSLocalizedString("modifier", comment: "Views / AddConfigView / highlights tuto 1"), NSLocalizedString("automatiquement", comment: "Views / AddConfigView / highlights tuto 1")]
    
    static let tutoTwo = NSLocalizedString("Entrez vos réglages et une période d'activation", comment: "Views / AddConfigView / tuto 2")
    static let highlightsTutoTwo = [NSLocalizedString("réglages", comment: "Views / AddConfigView / highlights tuto 1")]
}

struct AddConfigView_Previews: PreviewProvider {
    static var previews: some View {
        let contentManager = ContentManager()
        NavigationView {
            AddConfigView(speakerId: UUID())
                .environmentObject(contentManager)
                .preferredColorScheme(.dark)
        }
    }
}
