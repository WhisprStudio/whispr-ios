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

//    init() {
//        self.speakerName = speakerName
//        self.tmpSpeakerName = speakerName
//    }

    var body: some View {
        ListView(sections: [
            Section(items: [
                AnyView(PlaceholderDetectedSpeackersCell()),
                AnyView(TextFieldCell(text: $speakerName, label: "Name", placeholder: "My speaker")),
            ]),
            Section(items: [
                AnyView(SaveCell(action: {}))
            ])
        ], style: .plain)
        .separatorColor(Color.separator)
        .primaryColor(Color.primaryText)
        .backgroundColor(Color.fieldBackground)
        .navigationTitle("Add Speaker")
        .navigationBarTitleDisplayMode(.inline)
        .background(NavigationConfigurator())
    }
}

struct AddSpeakerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddSpeakerView()
                .preferredColorScheme(.dark)
        }
    }
}
