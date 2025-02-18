//
//  AdDetailMapperTests.swift
//  AdDetail
//
//  Created by Jack Uzcategui on 17/02/2025.
//

import XCTest
@testable import AdDetail

final class AdDetailMapperTests: XCTestCase {

    func testMapWithValidResponse() {
        let response = AdDetailResponse(
            _id: "123456789",
            title: "Test Item 1",
            description: "Test description for Item 1",
            pictures: ["image1.png"]
        )
        let mapper = AdDetailMapper()

        let model = mapper.map(response: response)

        XCTAssertEqual(model.id, "123456789")
        XCTAssertEqual(model.imageURL, "https://images.geev.fr/image1.png/squares/600")
        XCTAssertEqual(model.title, "Test Item 1")
        XCTAssertEqual(model.summary, "Test description for Item 1")
    }

    func testMapWithEmptyPictures() {
        let response = AdDetailResponse(
            _id: "123456789",
            title: "Test Item 1",
            description: "Test description for Item without image",
            pictures: []
        )
        let mapper = AdDetailMapper()

        let model = mapper.map(response: response)

        XCTAssertEqual(model.id, "123456789")
        XCTAssertEqual(model.imageURL, "")
        XCTAssertEqual(model.title, "Test Item 1")
        XCTAssertEqual(model.summary, "Test description for Item without image")
    }
}
