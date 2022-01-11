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
    var configName: String
    var isActive: Bool
    @EnvironmentObject var contentManager: ContentManager
    
    var body: some View {
        NavigationLink(destination: SpeakerConfigurationView(configName: configName)
                        .environmentObject(contentManager),
                       isActive: $isNavigationTriggered) {
            ButtonValueCell(label: configName,
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
    }
}

struct SpeakerConfigButtonCell_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SpeakerConfigButtonCell(configName: "test", isActive: true)
                .navigationTitle("Navigation")
                .preferredColorScheme(.dark)
        }
    }
}
