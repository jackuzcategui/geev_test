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
            CoordinatorSwitcher()
        }
    }
}
