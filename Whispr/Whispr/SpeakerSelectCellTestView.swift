//
//  SpeakerSelectCellTestView.swift
//  Whispr
//
//  Created by Paul Erny on 03/07/2021.
//

import SwiftUI

struct SpeakerSelectCellTestView: View {
    var body: some View {
        ScrollView {
            VStack {
                SpeakerSelectCell(label: "Speaker 1",
                                  speakerImage: "portable2",
                                  action: {})
                SpeakerSelectCell(label: "Speaker 2",
                                  speakerImage: "portable2",
                                  action: {})
                SpeakerSelectCell(label: "Speaker 3",
                                  speakerImage: "salon3",
                                  action: {})
                SpeakerSelectCell(label: "Speaker 4",
                                  speakerImage: "portable2",
                                  action: {})
                SpeakerSelectCell(label: "Speaker 5",
                                  speakerImage: "salon3",
                                  action: {})
                SpeakerSelectCell(label: "Speaker 6",
                                  speakerImage: "salon3",
                                  action: {})
                SpeakerSelectCell(label: "Speaker 7",
                                  speakerImage: "portable2",
                                  action: {})
                SpeakerSelectCell(label: "Speaker 8",
                                  speakerImage: "salon3",
                                  action: {})
                SpeakerSelectCell(label: "Speaker 9",
                                  speakerImage: "portable2",
                                  action: {})
                AddSpeakerCell(action: {})
            }
        }
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
