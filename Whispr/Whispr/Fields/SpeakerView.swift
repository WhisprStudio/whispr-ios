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
                    AnyView(TextFieldCell(text: $speakerName, label: "Name", placeholder: "My speaker", onEditingChange: self.onNameChange)),
                    AnyView(SliderCell(value: $volumeValue, onValueChanged: onVolumeChanged, label: "Volume")
                                .secondaryColor(.whisprYellow)),
                    AnyView(SliderCell(value: $noiseCancelingValue, onValueChanged: onNoiseCancelingChanged, label: "Noise canceling")
                                .secondaryColor(.whisprYellow)),
                ]),
                Section(items:
                            { () -> [AnyView] in
                                var configViews: [AnyView] = []
                                for (index, item) in speaker.configs.enumerated() {
                                    let isActive = index == 0 ? true : false
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
                                            if contentManager.tutorialStep == 4 {
                                                // go to step 5
                                                contentManager.saveTutorial()
                                            }
                                        }).environmentObject(contentManager)
                                    )
                                )
                                return configViews
                            }(),
                header: "Configurations"),
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
            if contentManager.tutorialStep == 3 ||
               contentManager.tutorialStep == 4 {
                TutoThree()
                    .environmentObject(contentManager)
            }
        }
    }
}

struct TutoThree: View {
    @EnvironmentObject var contentManager: ContentManager
    @State var makeTutoAppear = false
    var tutoTopText = "Here you can modify your Whispr speakers details"
    var tutoTopHighlighted = ["modify", "Whispr"]
    
    var tutoBotText = "Click on the button to add a new predefined configuration"
    var tutoBotHighlighted = ["button", "predefined"]
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: .infinity, height: 408)
                    .opacity(0.8)
                HighlightedText(text: tutoTopText, highlighted: tutoTopHighlighted, color: .whisprYellow)
                    .primaryFont(size: .L, weight: .medium)
                    .padding(.top, 120)
                    .offset(x: makeTutoAppear && contentManager.tutorialStep == 3 ? 0 : -380)
                    .opacity(makeTutoAppear && contentManager.tutorialStep == 3 ? 1 : 0)
                HighlightedText(text: tutoBotText, highlighted: tutoBotHighlighted, color: .whisprYellow)
                    .primaryFont(size: .L, weight: .medium)
                    .padding(10)
                    .padding(.top, 310)
                    .offset(x: contentManager.tutorialStep == 4 ? 0 : -380)
                    .opacity(contentManager.tutorialStep == 4 ? 1 : 0)
            }
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: 72)
                .opacity(contentManager.tutorialStep == 4 ? 0 : 0.8)
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: .infinity)
                .opacity(0.8)
        }
        .onTapGesture {
            if contentManager.tutorialStep == 3 {
                withAnimation(Animation.linear(duration: 0.2)) {
                    // go to step 4
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
