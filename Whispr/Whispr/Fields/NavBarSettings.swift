//
//  NavBarSettings.swift
//  Whispr
//
//  Created by Paul Erny on 15/10/2021.
//

import SwiftUI

struct NavigationConfigurator: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        let fontLarge = UIFont(name: "Barlow-SemiBold", size: 40)
        let fontSmall = UIFont(name: "Barlow-SemiBold", size: 28)

        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.primaryText), .font: fontLarge!]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(Color.primaryText), .font: fontSmall!]
    }
}
