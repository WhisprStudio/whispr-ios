//
//  PlaceholderDetectedSpeackersCell.swift
//  
//
//  Created by Paul Erny on 04/12/2021.
//

import SwiftUI

public struct DetectedSpeackersCell: View {
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading) {
            // TMP before real detection fo connected speaker
            Text("Connection")
                .primaryFont(size: .XL, weight: .semiBold)
            HStack (spacing: 16) {
                Text("Connecté à : ")
                    .primaryFont(size: .M, weight: .regular)
                Text("...")
                    .primaryFont(size: .L, weight: .thin)
                Spacer()
            }
            // !TMP
//            DeviceList()
        }
        //.frame(height: 200)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        DetectedSpeackersCell()
//            .preferredColorScheme(.dark)
    }
}
