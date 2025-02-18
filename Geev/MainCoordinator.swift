//
//  MainCoordinator.swift
//  Core
//
//  Created by Jack Uzcategui on 14/02/2025.
//

import Swinject
import Core
import AdListing
import AdDetail
import SwiftUI

final class MainCoordinator: Coordinating {
    let navigationState: NavigationState

    init(navigationState: NavigationState = NavigationState()) {
        self.navigationState = navigationState
    }

    func showAdDetail(adId: String) {
        navigationState.selectedAdId = adId
        navigationState.navigationPath.append(adId)
    }

    func popToRoot() {
        navigationState.navigationPath.removeLast(navigationState.navigationPath.count)
    }
}
