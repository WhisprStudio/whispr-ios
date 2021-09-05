//
//  SpeakerSelectCellTestView.swift
//  Whispr
//
//  Created by Paul Erny on 03/07/2021.
//

import SwiftUI
import WhisprDesignable

struct SpeakerSelectCellTestView: View {
    var body: some View {
        ListView(sections: [
            Section(items: [
                AnyView(SpeakerSelectCell(label: "Speaker 1",
                                          speakerImage: "portable2",
                                          action: {})),
                AnyView(SpeakerSelectCell(label: "Speaker 2",
                                          speakerImage: "portable2",
                                          action: {}))
            ], header: "header", footer: "footer"),
            Section(items: [
                AnyView(SpeakerSelectCell(label: "Speaker 3",
                                          speakerImage: "salon3",
                                          action: {})),
                AnyView(SpeakerSelectCell(label: "Speaker 4",
                                          speakerImage: "portable2",
                                          action: {})),
                AnyView(SpeakerSelectCell(label: "Speaker 5",
                                          speakerImage: "salon3",
                                          action: {})),
                AnyView(SpeakerSelectCell(label: "Speaker 6",
                                          speakerImage: "portable2",
                                          action: {})),
            ], header: "header", footer: "footer"),
            Section(items: [
                AnyView(AddSpeakerCell(action: {}))
            ])
        ], style: .plain)
    }
}

struct SpeakerSelectCellTestView_Previews: PreviewProvider {
    static var previews: some View {
        SpeakerSelectCellTestView()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color.background.edgesIgnoringSafeArea(.all))
            .preferredColorScheme(.dark)
    }
}
