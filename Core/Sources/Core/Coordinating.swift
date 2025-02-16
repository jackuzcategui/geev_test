//
//  Coordinating.swift
//  Core
//
//  Created by Jack Uzcategui on 13/02/2025.
//

import SwiftUI

public final class NavigationState: ObservableObject {
    @Published public var selectedAdId: String?
    @Published public var navigationPath = NavigationPath()

    public init() {}
}

public protocol Coordinating {
    var navigationState: NavigationState { get }
    func showAdDetail(adId: String)
    func popToRoot()
}
