//
//  PlaceholderDetectedSpeackersCell.swift
//  
//
//  Created by Paul Erny on 04/12/2021.
//

import SwiftUI

public struct PlaceholderDetectedSpeackersCell: View {
    public init() {}
    
    public var body: some View {
        VStack {
            Spacer()
        }.frame(height: 200)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderDetectedSpeackersCell()
            .preferredColorScheme(.dark)
    }
}
