//
//  RootViewUIKit.swift
//  Geev
//
//  Created by Jack Uzcategui on 16/02/2025.
//

import SwiftUI
import Core

struct RootViewUIKit: View {
    var body: some View {
        NavigationViewWrapper()
    }
}

struct NavigationViewWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let navigationController = UINavigationController()
        let coordinator = MainCoordinatorUIKit(container: DependencyResolver.shared.container,
                                               navigationController: navigationController)
        coordinator.start()
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
}
