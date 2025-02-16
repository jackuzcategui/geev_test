//
//  DependencyRegistration.swift
//  Geev
//
//  Created by Jack Uzcategui on 13/02/2025.
//

import Core
import Data
import AdListing
import AdDetail
import UIKit

extension DependencyResolver {
    func registerDependencies() {
        container.register(DataServiceProtocol.self) { _ in
            DataService()
        }.inObjectScope(.container)

        container.register(AdListingServiceProtocol.self) { resolver in
            AdListingService(dataService: resolver.resolve(DataServiceProtocol.self)!)
        }

        container.register(AdListingViewModel.self) { resolver in
            AdListingViewModel(service: resolver.resolve(AdListingServiceProtocol.self)!)
        }

        container.register(AdDetailServiceProtocol.self) { resolver in
            AdDetailService(dataService: resolver.resolve(DataServiceProtocol.self)!)
        }
    }
}
