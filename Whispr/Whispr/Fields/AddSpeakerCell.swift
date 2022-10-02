//
//  AddSpeakerCell.swift
//  Whispr
//
//  Created by Paul Erny on 03/07/2021.
//

import SwiftUI
import WhisprGenericViews

struct AddSpeakerCell: View {
    private var action: (() -> ())
    @State private var isClicked: Bool = false
    @State private var isNavigationTriggered: Bool = false
    @EnvironmentObject var contentManager: ContentManager
    
    init(action: @escaping (() -> ())) {
        self.action = action
    }

    var body: some View {
        NavigationLink(destination: AddSpeakerView()
                        .environmentObject(contentManager),
                       isActive: $isNavigationTriggered) {
            ButtonCell(label: Strings.new,
                   action: {
                    isClicked.toggle()
                    isNavigationTriggered = true
                    action()
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                        isClicked.toggle()
                    }
                   },
                   rightView: {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundColor(isClicked ? .success : .primaryText)
                            .primaryFont(size: .XL, weight: .medium)
                    }
                   })
            .primaryColor(Color.primaryText)
            .clickedColor(Color.success)
        }
    }
}

private struct Strings {
    static let new = NSLocalizedString("Nouvelle enceinte", comment: "Fields / AddSpeakerCell / add")
}

struct AddSpeakerCell_Previews: PreviewProvider {
    static var previews: some View {
        let contentManager = ContentManager()
        AddSpeakerCell(action: {})
            .environmentObject(contentManager)
            .preferredColorScheme(.dark)
    }
}
