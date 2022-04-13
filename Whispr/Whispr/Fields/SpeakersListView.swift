//
//  SpeakersListView.swift
//  Whispr
//
//  Created by Paul Erny on 15/10/2021.
//

import SwiftUI
import WhisprGenericViews

/// Application homepage
///
/// Displays the list of already added speakers (if any) followed by a button to add new speakers.
/// No parameters required for initialization.
struct SpeakersListView: View {
    @StateObject var contentManager = ContentManager()
    @State var tutoClicked = false
    @State var currentTutorialStep = 0

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ListView(sections: [
                        Section(items:
                            { () -> [AnyView] in
                                var speakerViews: [AnyView] = []
                                for item in contentManager.speakers {
                                    speakerViews.append(AnyView(
                                        SpeakerSelectCell(
                                            speaker: item,
                                            action: {
                                                // if the tutorial is on -> turn it of for this
                                                // view after the transition to the new view
                                                if contentManager.tutorialStep <= 2 {
//                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                        // go to step 3
                                                        contentManager.saveTutorial()
//                                                    }
                                                }
                                            },
                                            isConnected: true
                                        )
                                        .environmentObject(contentManager)
                                    ))
                                }
                                return speakerViews
                            }()
                        ),
                        Section(items: [
                            AnyView(AddSpeakerCell(action: {
                                // if the tutorial is on -> preset the text for the next step
                                // (after the speaker has been added)
                                if contentManager.tutorialStep < 2 {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        // go to step 2
                                        contentManager.saveTutorial()
                                    }
                                }
                            }).environmentObject(contentManager)
                            )
                        ])
                    ], style: .plain)
                    .separatorColor(Color.separator)
                    .primaryColor(Color.primaryText)
                    .backgroundColor(Color.fieldBackground)
                }
                .navigationTitle("Your speakers")
                .background(NavigationConfigurator())
                
                // -------- TUTORIAL VIEW --------
                if contentManager.tutorialStep < 2 {
                    TutoOne()
                        .environmentObject(contentManager)
                } else if contentManager.tutorialStep == 2 {
                    TutoTwo()
//                        .environmentObject(contentManager)
                }
            }
        }
    }
}

struct TutoOne: View {
    @EnvironmentObject var contentManager: ContentManager
    @State var tutoText = "Here you will find all your registered Whispr speakers"
    @State var tutoHighlighted = ["all", "Whispr"]
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: 193)
                .opacity(0.7)
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: 70)
                .opacity(contentManager.tutorialStep == 1 ? 0 : 0.7)
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: .infinity, height: .infinity)
                    .opacity(0.7)
                HighlightedText(text: tutoText, highlighted: tutoHighlighted, color: .whisprYellow)
                    .primaryFont(size: .L, weight: .medium)
                    .padding(.top, 20)
            }
        }
        .onTapGesture {
            if contentManager.tutorialStep == 0 {
                withAnimation(Animation.linear(duration: 0.2)) {
                    // go to step 1 (starting at 0)
                    contentManager.saveTutorial()
                    tutoText = "Click on the button to add a new speaker"
                    tutoHighlighted = ["button", "speaker"]
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct TutoTwo: View {
//    @EnvironmentObject var contentManager: ContentManager
    @State var tutoText = "Click on your new speaker to see its details"
    @State var tutoHighlighted = ["speaker"]
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: 148)
                .opacity(0.8)
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: 134)
                .opacity(0)
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: .infinity, height: .infinity)
                    .opacity(0.8)
                HighlightedText(text: tutoText, highlighted: tutoHighlighted, color: .whisprYellow)
                    .primaryFont(size: .L, weight: .medium)
                    .padding(.top, 20)
            }
        }
        .ignoresSafeArea()
    }
}

struct SpeakersListView_Previews: PreviewProvider {
    static var previews: some View {
        SpeakersListView()
            .preferredColorScheme(.dark)
    }
}
