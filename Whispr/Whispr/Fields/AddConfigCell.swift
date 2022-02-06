//
//  AddConfigCell.swift
//  Whispr
//
//  Created by Paul Erny on 04/12/2021.
//

import SwiftUI
//import WhisprGenericViews

struct AddConfigCell: View {
    private var action: (() -> ())
    private var speakerId: UUID
    @State private var isClicked: Bool = false
    @State private var isNavigationTriggered: Bool = false
    @EnvironmentObject var contentManager: ContentManager
    
    init(speakerId: UUID, action: @escaping (() -> ())) {
        self.speakerId = speakerId
        self.action = action
    }

    var body: some View {
        NavigationLink(destination: AddConfigView(speakerId: speakerId)
                        .environmentObject(contentManager),
                       isActive: $isNavigationTriggered) {
            ButtonCell(label: "Add Congfiguration",
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
//        .isDetailLink(false)
//        .onDisappear(perform: {
//            isNavigationTriggered = false
//        })
    }
}

struct AddConfigCell_Previews: PreviewProvider {
    static var previews: some View {
        AddConfigCell(speakerId: UUID(), action: {})
            .preferredColorScheme(.dark)
    }
}
