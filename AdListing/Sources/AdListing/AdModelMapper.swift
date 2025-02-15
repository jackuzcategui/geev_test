//
//  AdModelMapper.swift
//  AdListing
//
//  Created by Jack Uzcategui on 14/02/2025.
//

import CoreLocation

class AdModelMapper {
    func map(response: [AdListingData]) -> [AdModel] {
        let models = response.map {
            AdModel(id: $0._id,
                    imageURL: $0.pictures[0].squares128,
                    title: $0.title,
                    postedTime: formatTime(time: $0.creationDateMs),
                    distance: formatDistance(location: $0.location) )
        }
        return models
    }

    private func formatTime(time: Int64) -> String {
        let currentDate = Date()
        let eventDate = Date(timeIntervalSince1970: TimeInterval(time))
        let components = Calendar.current.dateComponents([.minute, .hour, .day], from: currentDate, to: eventDate)

        if let minutes = components.minute, minutes < 60 {
            return "\(minutes)min"
        } else if let hours = components.hour, hours < 24 {
            return "\(hours)h"
        } else if let days = components.day, days < 7 {
            return "\(days)d"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: eventDate)
        }
    }

    private func formatDistance(location: Location) -> String {
        let geeverLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let takerLocation = CLLocation(latitude: 44.836151, longitude: -0.580816)

        let distance = geeverLocation.distance(from: takerLocation)

        return distance < 1000 ? "\(Int(distance))m" : "\(Int(distance / 1000))km"
    }
}
