//
//  File.swift
//  AdListing
//
//  Created by Jack Uzcategui on 13/02/2025.
//

import Data

public protocol AdListingServiceProtocol: Sendable {
    func fetchAds(page: String?) async throws -> [String: String]
}

final public class AdListingService: AdListingServiceProtocol {
    private let dataService: DataServiceProtocol

    public init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }

    public func fetchAds(page: String? = nil) async throws -> [String: String] {
        try await dataService.request(endpoint: .adListing(page: page))
    }
}
