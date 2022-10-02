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
                                                if contentManager.tutorialStep <= 4 {
//                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                        // go to step 5
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
                                        // go to step 3
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
                .navigationTitle(Strings.title)
                .background(NavigationConfigurator())
                
                // -------- TUTORIAL VIEW --------
                if contentManager.tutorialStep < 2 {
                    TutoOne()
                        .environmentObject(contentManager)
                } else if contentManager.tutorialStep == 4 {
                    TutoTwo()
//                        .environmentObject(contentManager)
                }
            }
        }
    }
}

struct TutoOne: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var contentManager: ContentManager
    @State var tutoText = Strings.tutoOne
    @State var tutoHighlighted = Strings.highlightsTutoOne
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: 193)
                .opacity(colorScheme == .dark ? 0.7 : 0.9)
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: 70)
                .opacity(contentManager.tutorialStep == 1 ? 0 : (colorScheme == .dark ? 0.7 : 0.9))
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: .infinity, height: .infinity)
                    .opacity(colorScheme == .dark ? 0.7 : 0.9)
                HighlightedText(text: tutoText, highlighted: tutoHighlighted, color: .whisprYellow)
                    .foregroundColor(Color.TutorialText)
                    .primaryFont(size: .L, weight: .medium)
                    .padding(.top, 20)
            }
        }
        .onTapGesture {
            if contentManager.tutorialStep == 0 {
                withAnimation(Animation.linear(duration: 0.2)) {
                    // go to step 1 (starting at 0)
                    contentManager.saveTutorial()
                    tutoText = Strings.tutoOneBtn
                    tutoHighlighted = Strings.highlightstutoOneBtn
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct TutoTwo: View {
    @Environment(\.colorScheme) var colorScheme
    @State var tutoText = Strings.tutoTwo
    @State var tutoHighlighted = Strings.highlightsTutoTwo
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: 148)
                .opacity(colorScheme == .dark ? 0.7 : 0.9)
            Rectangle()
                .fill(Color.black)
                .frame(width: .infinity, height: 134)
                .opacity(0)
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: .infinity, height: .infinity)
                    .opacity(colorScheme == .dark ? 0.7 : 0.9)
                HighlightedText(text: tutoText, highlighted: tutoHighlighted, color: .whisprYellow)
                    .foregroundColor(Color.TutorialText)
                    .primaryFont(size: .L, weight: .medium)
                    .padding(.top, 20)
            }
        }
        .ignoresSafeArea()
    }
}

private struct Strings {
    static let title = NSLocalizedString("Mes Enceintes", comment: "Views / SpeakerListView / navTitle")
    static let tutoOne = NSLocalizedString("Ici, retrouvez toutes les enceintes Whispr que vous avez enregistrées", comment: "Views / SpeakerListView / tuto 1")
    static let highlightsTutoOne = [NSLocalizedString("toutes", comment: "Views / SpeakerListView / highlights tuto 1"), NSLocalizedString("Whispr", comment: "Views / SpeakerListView / highlights tuto 1")]
    static let tutoOneBtn = NSLocalizedString("Clickez sur le bouton pour ajouter une enceinte", comment: "Views / SpeakerListView / tuto 1 btn")
    static let highlightstutoOneBtn = [NSLocalizedString("bouton", comment: "Views / SpeakerListView / highlights tuto 1 btn"), NSLocalizedString("enceinte", comment: "Views / SpeakerListView / highlights tuto 1 btn")]
    static let tutoTwo = NSLocalizedString("Clickez sur votre nouvelle enceinte pour afficher ses détails", comment: "Views / SpeakerListView / tuto 2")
    static let highlightsTutoTwo = [NSLocalizedString("enceinte", comment: "Views / SpeakerListView / highlights tuto 2")]
}

struct SpeakersListView_Previews: PreviewProvider {
    static var previews: some View {
        SpeakersListView()
            .preferredColorScheme(.dark)
    }
}
