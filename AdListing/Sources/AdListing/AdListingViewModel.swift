//
//  File.swift
//  AdListing
//
//  Created by Jack Uzcategui on 13/02/2025.
//

import SwiftUI

public class AdListingViewModel: ObservableObject {
    public enum AdListingState {
        case loading
        case empty
        case error(String)
        case display([AdModel])
    }

    private let service: AdListingServiceProtocol
    private var after: String?

    @Published public var state: AdListingState = .loading

    public init(service: AdListingServiceProtocol) {
        self.service = service
    }

    @MainActor
    public func viewAppeared(refresh: Bool = false) async {
        guard case .loading = state else { return }
        state = .loading

        if refresh {
            after = nil
        }

        await fetchAds()
    }

    @MainActor
    private func fetchAds() async {
        do {
            let fetchedAds = try await self.service.fetchAds(page: nil)
            if fetchedAds.isEmpty {
                state = .empty
            } else {
                state = .display(fetchedAds)
                after = fetchedAds.last?.id
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

