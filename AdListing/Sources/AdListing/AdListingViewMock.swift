//
//  AdListinViewMock.swift
//  AdListing
//
//  Created by Jack Uzcategui on 18/02/2025.
//

import Core

final class AdListingServiceMock: AdListingServiceProtocol {
    func fetchAds(page: String?) async throws -> [AdModel] {
        return [AdModel(id: "1",
                        imageURL: "",
                        title: "Item 1",
                        postedTime: "2d",
                        distance: "1km"),
                AdModel(id: "2",
                                imageURL: "",
                                title: "Item 2",
                                postedTime: "2d",
                                distance: "1km"),
                AdModel(id: "3",
                                imageURL: "",
                                title: "Item 3",
                                postedTime: "2d",
                                distance: "1km"),
                AdModel(id: "4",
                                imageURL: "",
                                title: "Item 4",
                                postedTime: "2d",
                                distance: "1km")]
    }
}

final class MockCoordinator: Coordinating {
    var navigationState: Core.NavigationState

    init() {
        navigationState = NavigationState()
    }

    func showAdDetail(adId: String) {
    }

    func popToRoot() {
    }

}
