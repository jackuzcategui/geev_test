//
//  CoordinatorSwitcher.swift
//  Geev
//
//  Created by Jack Uzcategui on 17/02/2025.
//

import SwiftUI
import Core

struct CoordinatorSwitcher: View {
    @StateObject private var appState = AppState()

    var body: some View {
        VStack {
            switch appState.currentCoordinator {
            case .uiKit:
                RootViewUIKit()
            case .swiftUI:
                RootView(container: DependencyResolver.shared.container)
            }
        }

        Button(action: {
            appState.switchCoordinator()
        }) {
            Text("Switch to \(appState.currentCoordinator == .uiKit ? "SwiftUI" : "UIKit")")
                .padding()
                .background(.yellow)
                .foregroundColor(.black)
                .cornerRadius(8)
        }
        .padding()
    }
}
