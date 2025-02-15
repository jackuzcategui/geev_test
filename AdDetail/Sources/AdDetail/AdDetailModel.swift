//
//  AdDetailModel.swift
//  AdDetail
//
//  Created by Jack Uzcategui on 15/02/2025.
//

import Foundation

public struct AdDetailModel: Codable, Sendable, Identifiable {
    public let id: String
    let imageURL: String
    let title: String
    let summary: String
}
