//
//  AddSpeakerView.swift
//  Whispr
//
//  Created by Paul Erny on 04/12/2021.
//

import SwiftUI
//import WhisprGenericViews

struct AddSpeakerView: View {
    @State var speakerName: String = ""
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var contentManager: ContentManager

    var body: some View {
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
