//
//  AppState.swift
//  Geev
//
//  Created by Jack Uzcategui on 17/02/2025.
//

import SwiftUI

enum CoordinatorType {
    case uiKit
    case swiftUI
}

class AppState: ObservableObject {
    @Published var currentCoordinator: CoordinatorType = .uiKit

    func switchCoordinator() {
        currentCoordinator = currentCoordinator == .uiKit ? .swiftUI : .uiKit
    }
}
