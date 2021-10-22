//
//  SpeakersListView.swift
//  Whispr
//
//  Created by Paul Erny on 15/10/2021.
//

import SwiftUI
import WhisprGenericViews

struct SpeakersListView: View {
    @State var text: String = ""

    var body: some View {
        NavigationView {
            ListView(sections: [
                Section(items: [
                    AnyView(SpeakerSelectCell(label: "Speaker 1",
                                              speakerImage: "portable2",
                                              action: {},
                                              isConnected: true)),
                    AnyView(SpeakerSelectCell(label: "Speaker 2",
                                              speakerImage: "portable2",
                                              action: {},
                                              isConnected: false)),
                    AnyView(SpeakerSelectCell(label: "Speaker 3",
                                              speakerImage: "salon3",
                                              action: {},
                                              isConnected: false))
                ]),
                Section(items: [
                    AnyView(AddSpeakerCell(action: {}))
                ])
            ], style: .plain)
            .separatorColor(Color.separator)
            .primaryColor(Color.primaryText)
            .backgroundColor(Color.fieldBackground)
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
