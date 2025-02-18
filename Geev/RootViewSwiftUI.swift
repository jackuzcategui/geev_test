//
//  RootViewSwiftUI.swift
//  Geev
//
//  Created by Jack Uzcategui on 18/02/2025.
//

import SwiftUI
import Core
import Swinject
import AdListing
import AdDetail

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
                .navigationTitle(Text(""))
        }
    }
}
