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

struct RootView: View {
    @StateObject private var navigationState = NavigationState()
    private let coordinator: MainCoordinator
    private let container: Container

    init(container: Container) {
        let navigationState = NavigationState()
        self._navigationState = StateObject(wrappedValue: navigationState)
        self.coordinator = MainCoordinator(navigationState: navigationState)
        self.container = container
    }

    var body: some View {
        NavigationStack(path: $navigationState.navigationPath) {
            AdListingView(viewModel: container.resolve(AdListingViewModel.self)!, coordinator: coordinator)
                .navigationDestination(for: String.self) { adId in
                    let viewModel = AdDetailViewModel(service: container.resolve(AdDetailServiceProtocol.self)!, id: adId)
                    AdDetailViewControllerRepresentable(viewModel: viewModel)
                }
        }
    }
}
