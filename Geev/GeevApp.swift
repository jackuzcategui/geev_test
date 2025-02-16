//
//  GeevApp.swift
//  Geev
//
//  Created by Jack Uzcategui on 13/02/2025.
//

import SwiftUI
import Core

@main
struct GeevApp: App {
    init() {
        DependencyResolver.shared.registerDependencies()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
//            RootView(container: DependencyResolver.shared.container)
        }
    }
}

struct ContentView: View {
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
