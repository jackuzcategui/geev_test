//
//  File.swift
//  AdListing
//
//  Created by Jack Uzcategui on 13/02/2025.
//

import SwiftUI

public class AdListingViewModel: ObservableObject {
    private let service: AdListingServiceProtocol

    @Published public var ads: [AdModel] = []
    @Published public var errorMessage: String?

    public init(service: AdListingServiceProtocol) {
        self.service = service
    }

    @MainActor
    public func viewDidLoad() async {
        do {
            let fetchedAds = try await self.service.fetchAds(page: nil)
            ads = fetchedAds
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

