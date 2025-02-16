//
//  MainCoordinatorUIKit.swift
//  Geev
//
//  Created by Jack Uzcategui on 16/02/2025.
//

import UIKit
import AdListing
import AdDetail
import Core
import Swinject
import SwiftUI

class MainCoordinatorUIKit: Coordinating {
    var navigationState: Core.NavigationState
    private let container: Container

    private let navigationController: UINavigationController

    init(container: Container, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.container = container
        self.navigationState = .init()
    }

    func start() {
        let adListView = AdListingView(viewModel: container.resolve(AdListingViewModel.self)!, coordinator: self)
        let hostingController = UIHostingController(rootView: adListView)
        navigationController.pushViewController(hostingController, animated: false)
    }

    func showAdDetail(adId: String) {
        let adDetailView = AdDetailViewController(viewModel: AdDetailViewModel(service: container.resolve(AdDetailServiceProtocol.self)!,
                                                                               id: adId))
        navigationController.pushViewController(adDetailView, animated: true)

    }

    func popToRoot() {
        navigationController.popViewController(animated: true)
    }

}
