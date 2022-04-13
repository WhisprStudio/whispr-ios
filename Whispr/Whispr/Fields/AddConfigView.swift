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

            // -------- TUTORIAL VIEW --------
            // step 5 and 6
            if contentManager.tutorialStep == 5 ||
            contentManager.tutorialStep == 6 {
                TutoFour()
                    .environmentObject(contentManager)
            }
        }
    }
}

struct TutoFour: View {
    @EnvironmentObject var contentManager: ContentManager
    @State var makeTutoAppear = false
    @State var makeTutoDisappear = false
    var tutoTopText = "Here you can create your own predefined speakers configuration"
    var tutoTopHighlighted = ["create", "predefined"]
    
    var tutoBotText = "Fill in your desired settings and activation time"
    var tutoBotHighlighted = ["settings"]
    
    @State var test = 5
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: .infinity, height: 408)
                    .opacity(makeTutoDisappear ? 0 : 0.8)
                HighlightedText(text: tutoTopText, highlighted: tutoTopHighlighted, color: .whisprYellow)
                    .primaryFont(size: .L, weight: .medium)
                    .padding(.top, 120)
                    .offset(x: makeTutoAppear && contentManager.tutorialStep == 5 ? 0 : -380)
                    .opacity(makeTutoAppear && contentManager.tutorialStep == 5 ? 1 : 0)
                HighlightedText(text: tutoBotText, highlighted: tutoBotHighlighted, color: .whisprYellow)
                    .primaryFont(size: .L, weight: .medium)
                    .padding(10)
                    .padding(.top, 120)
                    .offset(x: contentManager.tutorialStep == 6 ? 0 : 300)
                    .opacity(makeTutoDisappear ? 0 : 1)
            }
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: 72)
                .opacity(makeTutoDisappear ? 0 : 0.8)
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: .infinity)
                .opacity(makeTutoDisappear ? 0 : 0.8)
        }
        .onTapGesture {
            if contentManager.tutorialStep == 5 {
                withAnimation(Animation.linear(duration: 0.2)) {
                    // go to step 6
                    contentManager.saveTutorial()
                }
            } else if contentManager.tutorialStep == 6 {
                withAnimation(Animation.linear(duration: 0.2)) {
                    // remove tutorial / step 7
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
