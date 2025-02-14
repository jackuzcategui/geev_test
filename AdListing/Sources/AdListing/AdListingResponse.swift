//
//  AdListingResponse.swift
//  Data
//
//  Created by Jack Uzcategui on 14/02/2025.
//

struct AdListingResponse: Codable {
    let data: [AdListingData]
}

struct AdListingData: Codable {
    let _id: String
    let title: String
    let creationDateMs: Int64
    let location: Location
    let pictures: [Picture]
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}

struct Picture: Codable {
    let squares32: String
    let squares64: String
    let squares128: String
}
