//
//  Endpoint.swift
//  Data
//
//  Created by Jack Uzcategui on 13/02/2025.
//

import Alamofire

public enum Endpoint: Sendable {
    case adListing(page: String?)
    case adDetail(id: String)

    var path: String {
        switch self {
        case .adListing(let page):
            guard let pagination = page else { return "v2/search/items/geo?limit=26" }
            return "v2/search/items/geo?limit=26&after=\(pagination)"
        case .adDetail(id: let id):
            return "v1/api/v0.19/articles/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .adListing:
                .post
        case .adDetail:
                .get
        }
    }

    var parameters: [String: any Any & Sendable]? {
        switch self {
        case .adListing:
            let params: [String: any Any & Sendable] = [
                "type": ["donation"],
                "distance": 10000,
                "donationState": ["open", "reserved"],
                "latitude": 44.838069099999998,
                "universe": ["object"],
                "longitude": -0.5777678000000000
            ]
            return params
        case .adDetail:
            return nil
        }
    }
}
