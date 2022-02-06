//
//  SpeakerConfigButtonCell.swift
//  Whispr
//
//  Created by Paul Erny on 05/11/2021.
//

//import WhisprGenericViews
import SwiftUI

struct SpeakerConfigButtonCell: View {
    @State private var isNavigationTriggered: Bool = false
    var config: SpeakerConfig
    var speakerId: UUID
    var isActive: Bool
    @EnvironmentObject var contentManager: ContentManager
    
    var body: some View {
        NavigationLink(destination: SpeakerConfigurationView(config: config, speakerId: speakerId)
                        .environmentObject(contentManager),
                       isActive: $isNavigationTriggered) {
            ButtonValueCell(label: config.name,
                            value: isActive ? "active" : "inactive",
                            action: {
                                isNavigationTriggered = true
                            },
                            leftView: {
                                Image(systemName: "square.fill")
                                    .foregroundColor(.white)
                                    .primaryFont(size: .XL, weight: .medium)
                            })
        }
//        .isDetailLink(false)
//        .onDisappear(perform: {
//            isNavigationTriggered = false
//        })
    }
}

struct SpeakerConfigButtonCell_Previews: PreviewProvider {
    static var previews: some View {
        let contentManager = ContentManager()

        NavigationView {
            SpeakerConfigButtonCell(config: SpeakerConfig(name: "Home", volume: 50, noiseCanceling: 50), speakerId: UUID(), isActive: true)
                .environmentObject(contentManager)
                .navigationTitle("Navigation")
                .preferredColorScheme(.dark)
        }
    }
}
