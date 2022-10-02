//
//  AddSpeakerView.swift
//  Whispr
//
//  Created by Paul Erny on 04/12/2021.
//

import SwiftUI
import WhisprGenericViews

struct AddSpeakerView: View {
    @State var speakerName: String = ""
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var contentManager: ContentManager
    @State var stateTuto = false

    var body: some View {
        ZStack {
            ListView(sections: [
                Section(items: [
                    AnyView(DetectedSpeackersCell()),
                    AnyView(TextFieldCell(text: $speakerName, label: Strings.nameLabel, placeholder: Strings.namePlaceholder)),
                ]),
                Section(items: [
                    AnyView(SaveCell(action: {
                        if !speakerName.isEmpty {
                            contentManager.add(Speaker(name: speakerName))
                            self.mode.wrappedValue.dismiss()
                            contentManager.saveTutorial()
                        }
                    }))
                ])
            ], style: .plain)
            .separatorColor(Color.separator)
            .primaryColor(Color.primaryText)
            .backgroundColor(Color.fieldBackground)
            .navigationTitle(Strings.title)
            .navigationBarTitleDisplayMode(.inline)
            .background(NavigationConfigurator())
            
//            if contentManager.tutorialStep == 2 {
//                Tuto()
//                    .environmentObject(contentManager)
//            }
            /*else*/ if contentManager.tutorialStep == 2 {
                TutorialTwo()
                    .environmentObject(contentManager)
            }
            else if contentManager.tutorialStep == 3 {
                TutorialThree()
            }
        }
    }
}

struct Tuto: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var contentManager: ContentManager
    @State var tutoText = "On this page you'll push the button 'Start Scanning' to search your speaker ! After that you'll save your speaker to enter a name and save it."
    @State var tutoHighlighted = ["push", "Start Scanning", "speaker", "save", "enter", "name"]
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: 182)
                .opacity(colorScheme == .dark ? 0.7 : 0.9)
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 26, height: 57)
                    .opacity(colorScheme == .dark ? 0.7 : 0.9)
                Rectangle()
                    .frame(width: 295, height: 57)
                    .opacity(0)
                Rectangle()
                    .fill(Color.black)
                    .frame(width: .infinity, height: 57)
                    .opacity(colorScheme == .dark ? 0.7 : 0.9)
            }
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: .infinity, height: .infinity)
                    .opacity(colorScheme == .dark ? 0.7 : 0.9)
                HighlightedText(text: tutoText, highlighted: tutoHighlighted, color: .whisprYellow)
                    .foregroundColor(Color.TutorialText)
                    .primaryFont(size: .L, weight: .medium)
                    .padding(.top, 140)
            }
            .opacity(1)
        }
        .onTapGesture {
            contentManager.saveTutorial()
        }
        .ignoresSafeArea()
    }
}

struct TutorialTwo: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var contentManager: ContentManager
    @State var tutoText = Strings.tutoOne
    @State var tutoHighlighted = Strings.highlightsTutoOne
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: 204)
                .opacity(colorScheme == .dark ? 0.7 : 0.9)
                Rectangle()
                    .frame(width: .infinity, height: 67)
                    .opacity(0)
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: .infinity, height: .infinity)
                    .opacity(colorScheme == .dark ? 0.7 : 0.9)
                HighlightedText(text: tutoText, highlighted: tutoHighlighted, color: .whisprYellow)
                    .foregroundColor(Color.TutorialText)
                    .primaryFont(size: .L, weight: .medium)
                    .padding(.top, 140)
            }
            .opacity(1)
        }
        .onTapGesture {
            contentManager.saveTutorial()
        }
        .ignoresSafeArea()
    }
}

struct TutorialThree: View {
    @Environment(\.colorScheme) var colorScheme
    @State var tutoText = Strings.tutoTwo
    @State var tutoHighlighted = Strings.highlightsTutoTwo
    @State var stateTuto = false
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: 315)
                .opacity(stateTuto == false ? (colorScheme == .dark ? 0.7 : 0.9) : 0)
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: 70)
                .opacity(0)
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: .infinity, height: .infinity)
                    .opacity(stateTuto == false ? (colorScheme == .dark ? 0.7 : 0.9) : 0)
                HighlightedText(text: tutoText, highlighted: tutoHighlighted, color: .whisprYellow)
                    .foregroundColor(Color.TutorialText)
                    .primaryFont(size: .L, weight: .medium)
                    .padding(.top, 80)
            }
        }
        .onTapGesture {
            if stateTuto == false {
                stateTuto = true
            }
        }
        .ignoresSafeArea()
    }
}

private struct Strings {
    static let title = NSLocalizedString("Nouvelle enceinte", comment: "Views / AddSpeakerView / navTitle")
    static let nameLabel = NSLocalizedString("Nom", comment: "Views / AddSpeakerView / name cell label")
    static let namePlaceholder = NSLocalizedString("Mon enceinte", comment: "Views / AddSpeakerView / name cell placeholder")
    
    
    
    static let tutoOne = NSLocalizedString("Si vous êtes connecté à la bonne enceinte, choisissez son nom", comment: "Views / AddSpeakerView / tuto 1")
    static let highlightsTutoOne = [NSLocalizedString("choisissez", comment: "Views / SpeakerListView / highlights tuto 1"), NSLocalizedString("connecté", comment: "Views / AddSpeakerView / highlights tuto 1")]
    
    static let tutoTwo = NSLocalizedString("Maintenant, enregistez votre nouvelle enceinte Whsipr !", comment: "Views / AddSpeakerView / tuto 2")
    static let highlightsTutoTwo = [NSLocalizedString("enregistez", comment: "Views / SpeakerListView / highlights tuto 1"), NSLocalizedString("Whispr", comment: "Views / AddSpeakerView / highlights tuto 2")]
}

struct AddSpeakerView_Previews: PreviewProvider {
    static var previews: some View {
        let content = ContentManager()
        NavigationView {
            AddSpeakerView()
                .environmentObject(content)
                .preferredColorScheme(.dark)
        }
    }
}
