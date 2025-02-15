//
//  AdListingViewModel.swift
//  AdListing
//
//  Created by Jack Uzcategui on 13/02/2025.
//

import SwiftUI

public class AdListingViewModel: ObservableObject {
    public enum State {
        case loading
        case empty
        case error(String)
        case display
    }

    private let service: AdListingServiceProtocol
    private var after: String?

    @Published public var state: State = .loading
    @Published private(set) var ads: [AdModel] = []
    @Published private(set) var isLoadingMore = false

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
                state = .display
                ads = fetchedAds
                after = fetchedAds.last?.id
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    @MainActor
    public func didDisplayLastItem() async {
        guard !isLoadingMore, after != nil else { return }
        isLoadingMore = true

        Task {
            do {
                let fetchedAds = try await self.service.fetchAds(page: after)
                withAnimation {
                    ads.append(contentsOf: fetchedAds)
                }
                after = fetchedAds.last?.id
                state = .display
            } catch {
                state = .display
            }
            isLoadingMore = false
        }
    }
}
