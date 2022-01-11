//
//  SpeakersListView.swift
//  Whispr
//
//  Created by Paul Erny on 15/10/2021.
//

import SwiftUI
//import WhisprGenericViews

struct SpeakersListView: View {
    @StateObject var contentManager = ContentManager()

    var body: some View {
        NavigationView {
            VStack {
                ListView(sections: [
                    Section(items:
                        { () -> [AnyView] in
                            var speakerViews: [AnyView] = []
                            for item in contentManager.speakers {
                                speakerViews.append(AnyView(
                                    SpeakerSelectCell(
                                        speaker: item,
                                        action: {},
                                        isConnected: true
                                    )
                                    .environmentObject(contentManager)
                                ))
                            }
                            return speakerViews
                        }()
                    ),
                    Section(items: [
                        AnyView(AddSpeakerCell(action: {})
                                    .environmentObject(contentManager)
                        )
                    ])
                ], style: .plain)
                .separatorColor(Color.separator)
                .primaryColor(Color.primaryText)
                .backgroundColor(Color.fieldBackground)
            }
            .navigationTitle("Your speakers")
            .background(NavigationConfigurator())
        }
    }
}

struct SpeakersListView_Previews: PreviewProvider {
    static var previews: some View {
        SpeakersListView()
//            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
//            .background(Color.background.edgesIgnoringSafeArea(.all))
            .preferredColorScheme(.dark)
    }
}
