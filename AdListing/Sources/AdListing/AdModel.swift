//
//  AdModel.swift
//  AdListing
//
//  Created by Jack Uzcategui on 14/02/2025.
//

import Foundation

public struct AdModel: Codable, Sendable {
    // all inside "data" array
    let id: String // _id
    let imageURL: String // pictures" squares32.64.128.300.600
    let title: String // title
    let postedTime: Date? // creationDateMs
    let distance: String // location: latitude longitude
}
