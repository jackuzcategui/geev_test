//
//  AdModelMapper.swift
//  AdListing
//
//  Created by Jack Uzcategui on 14/02/2025.
//

import CoreLocation

class AdModelMapper {
    static func map(response: [AdListingData]) -> [AdModel] {
        let models = response.map {
            AdModel(id: $0._id,
                    imageURL: $0.pictures[0].squares32,
                    title: $0.title,
                    postedTime: Date(timeIntervalSince1970: TimeInterval($0.creationDateMs) / 1000),
                    distance: AdModelMapper.formatDistance(location: $0.location) )
        }
        return models
    }

    private static func formatDistance(location: Location) -> String {
        let geeverCoordinates = (latitude: location.latitude, longitude: location.longitude)
        let takerCoordinates = (latitude: 48.85661, longitude: 2.35222)

        let geeverLocation = CLLocation(latitude: geeverCoordinates.latitude, longitude: geeverCoordinates.longitude)
        let takerLocation = CLLocation(latitude: takerCoordinates.latitude, longitude: takerCoordinates.longitude)

        return "\(Int(geeverLocation.distance(from: takerLocation)))m"
    }
}
