//
//  AdModel.swift
//  AdListing
//
//  Created by Jack Uzcategui on 14/02/2025.
//

import Foundation

public struct AdModel: Codable, Sendable, Identifiable {
    public let id: String
    let imageURL: String
    let title: String
    let postedTime: String
    let distance: String
}
