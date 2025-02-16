// The Swift Programming Language
// https://docs.swift.org/swift-book

import Swinject

public class DependencyResolver {
    @MainActor
    public static let shared = DependencyResolver()
    public let container: Container

    private init () {
        container = Container()
    }

    public func register<T>(_ type: T.Type, factory: @escaping (Resolver) -> T) {
        container.register(type, factory: factory)
    }

    public func resolve<T>(_ type: T.Type) -> T {
        guard let instance = container.resolve(type) else { fatalError("Could not resolve \(type)") }
        return instance
    }
}
