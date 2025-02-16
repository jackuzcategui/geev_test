// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Alamofire
import Core

public protocol DataServiceProtocol: Sendable {
    func request<T: Decodable & Sendable>(endpoint: Endpoint) async throws -> T
}

final public class DataService: DataServiceProtocol {
    private let session: Session
    private let baseURL = "https://prod.geev.fr"

    public init(session: Session = .default) {
        self.session = session
    }

    public func request<T: Decodable & Sendable>(endpoint: Endpoint) async throws -> T {
        let url = "\(baseURL)/\(endpoint.path)"

        let request = session
            .request(url,
                     method: endpoint.method,
                     parameters: endpoint.parameters,
                     encoding: endpoint.method == .get ? URLEncoding.default : JSONEncoding.default)
            .validate()

        return try await withCheckedThrowingContinuation { continuation in
            request.responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: self.parseError(error))
                }
            }
        }
    }

    private func parseError(_ error: Error) -> NetworkError {
        let mappedError: NetworkError

        if let afError = error as? AFError {
            switch afError {
            case .responseSerializationFailed:
                mappedError = .decodingFailed(afError)
            default:
                mappedError = .requestFailed(afError)
            }
        } else {
            mappedError = .unknown
        }
        print("Error: \(mappedError)")
        return mappedError
    }
}
