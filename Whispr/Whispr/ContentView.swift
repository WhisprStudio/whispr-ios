//
//  ContentView.swift
//  Whispr
//
//  Created by Paul Erny on 08/06/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Italic XXL")
                .padding()
                .foregroundColor(.success)
                .primaryFont(size: .XXL, weight: .thin)
            Text("Medium XXL")
                .padding()
                .foregroundColor(.success)
                .primaryFont(size: .XXL, weight: .medium)
            Text("Regular XL")
                .padding()
                .foregroundColor(.success)
                .primaryFont(size: .XL, weight: .regular)
            Text("Regular L")
                .padding()
                .foregroundColor(.success)
                .primaryFont(size: .L, weight: .regular)
            Text("Medium M")
                .padding()
                .foregroundColor(.LED)
                .primaryFont(size: .M, weight: .medium)
            Text("Medium S")
                .padding()
                .foregroundColor(.error)
                .primaryFont(size: .S, weight: .medium)
            Text("Regular XS")
                .padding()
                .foregroundColor(.error)
                .primaryFont(size: .XS, weight: .regular)
            Text("Medium XXS")
                .padding()
                .foregroundColor(.error)
                .primaryFont(size: .XXS, weight: .medium)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.background.edgesIgnoringSafeArea(.all))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
