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
                    AnyView(PlaceholderDetectedSpeackersCell()),
                    AnyView(TextFieldCell(text: $speakerName, label: "Name", placeholder: "My speaker")),
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
            .navigationTitle("Add Speaker")
            .navigationBarTitleDisplayMode(.inline)
            .background(NavigationConfigurator())
            
            if contentManager.tutorialStep == 2 {
                Tuto()
                    .environmentObject(contentManager)
            }
            else if contentManager.tutorialStep == 3 {
                TutorialTwo()
                    .environmentObject(contentManager)
            }
            else if contentManager.tutorialStep == 4 {
                TutorialThree()
                    .environmentObject(contentManager)
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
    @State var tutoText = "Here is to enter the name of your speaker when it will be selected"
    @State var tutoHighlighted = ["name", "speaker", "selected"]
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: 267)
                .opacity(colorScheme == .dark ? 0.7 : 0.9)
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 24, height: 70)
                    .opacity(colorScheme == .dark ? 0.7 : 0.9)
                Rectangle()
                    .frame(width: 369, height: 70)
                    .opacity(0)
                Rectangle()
                    .fill(Color.black)
                    .frame(width: .infinity, height: 70)
                    .opacity(colorScheme == .dark ? 0.7 : 0.9)
            }
//                .opacity(contentManager.tutorialStep == 1 ? 0 : 0.7)
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
    @EnvironmentObject var contentManager: ContentManager
    @State var tutoText = "And you click on save, to save your speaker, let's try"
    @State var tutoHighlighted = ["name", "speaker", "selected"]
    @State var stateTuto = false
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: 387)
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
//            .opacity(stateTuto == false ? 0.7 : 0Whispr/Whispr/ColorManager.swift)
        }
        .onTapGesture {
            if stateTuto == false {
                stateTuto = true
            }
        }
        .ignoresSafeArea()
    }
}

struct AddSpeakerView_Previews: PreviewProvider {
    static var previews: some View {
        let content = ContentManager()
        NavigationView {
            AddSpeakerView()
                .environmentObject(content)
//                .preferredColorScheme(.dark)
        }
    }
}
