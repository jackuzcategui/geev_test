//
//  AdDetailService.swift
//  AdDetail
//
//  Created by Jack Uzcategui on 15/02/2025.
//

import Data

public protocol AdDetailServiceProtocol: Sendable {
    func fetchDetail(id: String) async throws -> AdDetailModel
}

final public class AdDetailService: AdDetailServiceProtocol {
    private let dataService: DataServiceProtocol

    public init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }

    public func fetchDetail(id: String) async throws -> AdDetailModel {
        let response: AdDetailResponse = try await dataService.request(endpoint: .adDetail(id: id))
        return AdDetailMapper().map(response: response)
    }
}
