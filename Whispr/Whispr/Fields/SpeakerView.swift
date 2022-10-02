//
//  SpeakerView.swift
//  Whispr
//
//  Created by Paul Erny on 15/10/2021.
//

import SwiftUI
import WhisprGenericViews

/// Speaker details
///
/// Displayed when clicking on a speaker from the homepage. This view shows the name, current volume and
/// noise canceling settings of the speaker as well as existing conficurations (if any) followed by a button to add
/// new configurations to the speaker.
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
        ZStack {
            ListView(sections: [
                Section(items: [
                    AnyView(TextFieldCell(text: $speakerName, label: Strings.nameLabel, placeholder: Strings.namePlaceholder, onEditingChange: self.onNameChange)),
                    AnyView(SliderCell(value: $volumeValue, onValueChanged: onVolumeChanged, label: Strings.volumeLabel)
                                .secondaryColor(.whisprYellow)),
                    AnyView(SliderCell(value: $noiseCancelingValue, onValueChanged: onNoiseCancelingChanged, label: Strings.noiseCancelingLabel)
                                .secondaryColor(.whisprYellow)),
                ]),
                Section(items:
                            { () -> [AnyView] in
                                var configViews: [AnyView] = []
                                let calendar = Calendar.current
                                var isActive = false
                                for item in speaker.configs {
                                    if item.hasTimeTrigger {
                                        var startTime = Date(timeIntervalSinceReferenceDate: TimeInterval.zero)
                                        var endTime = Date(timeIntervalSinceReferenceDate: TimeInterval.zero)
                                        var currentTime = Date(timeIntervalSinceReferenceDate: TimeInterval.zero)

                                        let startDateComponents = calendar.dateComponents([.hour, .minute], from: item.startTime)
                                        let endTimeComponents = calendar.dateComponents([.hour, .minute], from: item.endTime)
                                        let currentTimeComponents = calendar.dateComponents([.hour, .minute], from: Date())

                                        startTime = calendar.date(byAdding: startDateComponents, to: startTime)!
                                        endTime = calendar.date(byAdding: endTimeComponents, to: endTime)!
                                        currentTime = calendar.date(byAdding: currentTimeComponents, to: currentTime)!
                                        
                                        isActive = (startTime < currentTime && endTime > currentTime) ? true : false
                                    } else {
                                        isActive = item.isActive
                                    }
                                    
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
                                    AnyView(AddConfigCell(speakerId: speaker.id, action:
                                        {
                                            if contentManager.tutorialStep == 6 {
                                                // go to step 7
                                                contentManager.saveTutorial()
                                            }
                                        }).environmentObject(contentManager)
                                    )
                                )
                                return configViews
                            }(),
                        header: Strings.configHeaderLabel),
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
            
            // -------- TUTORIAL VIEW --------
            if contentManager.tutorialStep == 5 ||
               contentManager.tutorialStep == 6 {
                TutoThree()
                    .environmentObject(contentManager)
            }
        }
    }
}

struct TutoThree: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var contentManager: ContentManager
    @State var makeTutoAppear = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: .infinity, height: 408)
                    .opacity(colorScheme == .dark ? 0.7 : 0.9)
                HighlightedText(text: Strings.tutoOne, highlighted: Strings.highlightsTutoOne, color: .whisprYellow)
                    .foregroundColor(Color.TutorialText)
                    .primaryFont(size: .L, weight: .medium)
                    .padding(.top, 120)
                    .offset(x: makeTutoAppear && contentManager.tutorialStep == 5 ? 0 : -380)
                    .opacity(makeTutoAppear && contentManager.tutorialStep == 5 ? 1 : 0)
                HighlightedText(text: Strings.tutoTwo, highlighted: Strings.highlightsTutoTwo, color: .whisprYellow)
                    .foregroundColor(Color.TutorialText)
                    .primaryFont(size: .L, weight: .medium)
                    .padding(10)
                    .padding(.top, 310)
                    .offset(x: contentManager.tutorialStep == 6 ? 0 : -380)
                    .opacity(contentManager.tutorialStep == 6 ? 1 : 0)
            }
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: 72)
                .opacity(contentManager.tutorialStep == 6 ? 0 : (colorScheme == .dark ? 0.7 : 0.9))
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: .infinity)
                .opacity(colorScheme == .dark ? 0.7 : 0.9)
        }
        .onTapGesture {
            if contentManager.tutorialStep == 5 {
                withAnimation(Animation.linear(duration: 0.2)) {
                    // go to step 7
                    contentManager.saveTutorial()
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
    static let nameLabel = NSLocalizedString("Nom", comment: "Views / SpeakerView / name cell label")
    static let namePlaceholder = NSLocalizedString("Mon enceinte", comment: "Views / SpeakerView / name cell placeholder")
    static let volumeLabel = NSLocalizedString("Volume", comment: "Views / SpeakerView / volume cell label")
    static let noiseCancelingLabel = NSLocalizedString("Reduction du bruit", comment: "Views / SpeakerView / noise canceling cell placeholder")
    static let configHeaderLabel = NSLocalizedString("Mes configurations", comment: "Views / SpeakerView / config section header")

    static let tutoOne = NSLocalizedString("Ici, vous pouvez modifier les configurations de vos enceintes Whispr", comment: "Views / SpeakerView / tuto 1")
    static let highlightsTutoOne = [NSLocalizedString("modifier", comment: "Views / SpeakerView / highlights tuto 1"), NSLocalizedString("Whispr", comment: "Views / SpeakerView / highlights tuto 1")]
    
    static let tutoTwo = NSLocalizedString("Clickez sur le bouton pour ajouter une nouvelle configuration !", comment: "Views / SpeakerView / tuto 2")
    static let highlightsTutoTwo = [NSLocalizedString("bouton", comment: "Views / SpeakerView / highlights tuto 1"), NSLocalizedString("configuration", comment: "Views / SpeakerView / highlights tuto 2")]
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
