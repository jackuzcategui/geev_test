//
//  NetworkError.swift
//  Data
//
//  Created by Jack Uzcategui on 14/02/2025.
//

enum NetworkError: Error, Equatable {
    case invalidURL
    case requestFailed(Error)
    case decodingFailed(Error)
    case unknown

    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}
