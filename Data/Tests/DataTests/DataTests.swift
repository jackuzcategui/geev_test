//
//  DataTests.swift
//  Data
//
//  Created by Jack Uzcategui on 14/02/2025.
//

import XCTest
import Alamofire
@testable import Data

final class DataTests: XCTestCase {
    var service: DataService!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = Session(configuration: configuration)

        service = DataService(session: session)
    }

    func testRequestSuccessfulResponse() async throws {
        let mockJSON = """
            {
                "id": "123456",
                "title": "Goals at Tottenham Stadium",
                "description": "They just giving them away man",
                "imageUrl": "ange.jpg"
            }
            """.data(using: .utf8)!

        let url = URL(string: "http://testEndpoint")!
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!

        MockURLProtocol.requestHandler = { _ in
            return (urlResponse, mockJSON)
        }

        struct MockResponse: Decodable {
            let id: String
            let title: String
            let description: String
            let imageUrl: String
        }

        let endpoint = Endpoint.adListing(page: nil)
        let result: MockResponse = try await service.request(endpoint: endpoint)

        XCTAssertEqual(result.id, "123456")
        XCTAssertEqual(result.title, "Goals at Tottenham Stadium")
        XCTAssertEqual(result.description, "They just giving them away man")
        XCTAssertEqual(result.imageUrl, "ange.jpg")
    }

    func testRequestDecodingFailure() async {
        let invalidJSON = "Invalid JSON".data(using: .utf8)!
        let urlResponse = HTTPURLResponse(url: URL(string: "https://prod.geev.fr/testEndpoint")!,
                                          statusCode: 200, httpVersion: nil, headerFields: nil)!

        MockURLProtocol.requestHandler = { _ in
            return (urlResponse, invalidJSON)
        }

        struct MockResponse: Decodable {
            let id: String
            let title: String
        }

        let endpoint = Endpoint.adListing(page: nil)

        do {
            let _: MockResponse = try await service.request(endpoint: endpoint)
            XCTFail("Expected decoding failure but got success.")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .decodingFailed(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testRequestNetworkFailure() async {
        let networkError = NSError(domain: "TestNetworkError", code: -1009, userInfo: nil)

        MockURLProtocol.requestHandler = { _ in
            throw networkError
        }

        struct MockResponse: Decodable {
            let id: String
            let title: String
        }

        let endpoint = Endpoint.adListing(page: nil)

        do {
            let _: MockResponse = try await service.request(endpoint: endpoint)
            XCTFail("Expected network failure but got success.")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .requestFailed(AFError.sessionTaskFailed(error: networkError)))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
