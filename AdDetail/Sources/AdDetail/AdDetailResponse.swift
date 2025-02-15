//
//  AdDetailResponse.swift
//  AdDetail
//
//  Created by Jack Uzcategui on 15/02/2025.
//

struct AdDetailResponse: Codable, Sendable {
    let _id: String
    let title: String
    let description: String
    let pictures: [String]
}
