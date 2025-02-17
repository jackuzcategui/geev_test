//
//  AdListingMapperTests.swift
//  AdListing
//
//  Created by Jack Uzcategui on 17/02/2025.
//

import XCTest
import CoreLocation
@testable import AdListing

final class AdModelMapperTests: XCTestCase {

    var mapper: AdModelMapper!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mapper = AdModelMapper()
    }

    override func tearDownWithError() throws {
        mapper = nil
        try super.tearDownWithError()
    }

    func testMapper() {
        let response = [AdListingData(_id: "123456789",
                                      title: "Test Item 1",
                                      creationDateMs: Int64(Date().timeIntervalSince1970 - 600),
                                      location: Location(latitude: 44.84044, longitude: -0.5805),
                                      pictures: [Picture(squares32: "image1@32x32.png",
                                                         squares64: "image1@64x64.png",
                                                         squares128: "image1@128x128.png")]),
                        AdListingData(_id: "654987982",
                                      title: "Test Item 2",
                                      creationDateMs: Int64(Date().timeIntervalSince1970 - 3600),
                                      location: Location(latitude: 44.84044, longitude: -0.5805),
                                      pictures: [Picture(squares32: "image2@32x32.png",
                                                         squares64: "image2@64x64.png",
                                                         squares128: "image2@128x128.png")])]

        let models = mapper.map(response: response)

        XCTAssertEqual(models.count, 2)
        XCTAssertEqual(models[0].id, "123456789")
        XCTAssertEqual(models[0].title, "Test Item 1")
        XCTAssertEqual(models[0].imageURL, "image1@128x128.png")
        XCTAssertEqual(models[1].id, "654987982")
        XCTAssertEqual(models[1].title, "Test Item 2")
        XCTAssertEqual(models[1].imageURL, "image2@128x128.png")
    }

    func testFormatTime() {
        let now = Date()
        let tenMinutesAgo = Int64(now.addingTimeInterval(660).timeIntervalSince1970)
        let twoHoursAgo = Int64(now.addingTimeInterval(7260).timeIntervalSince1970)
        let fiveDaysAgo = Int64(now.addingTimeInterval(432060).timeIntervalSince1970)

        let response = [AdListingData(_id: "123456789",
                                      title: "Test Item 1",
                                      creationDateMs: tenMinutesAgo,
                                      location: Location(latitude: 44.84044, longitude: -0.5805),
                                      pictures: [Picture(squares32: "image1@32x32.png",
                                                         squares64: "image1@64x64.png",
                                                         squares128: "image1@128x128.png")]),
                        AdListingData(_id: "654987982",
                                      title: "Test Item 2",
                                      creationDateMs: twoHoursAgo,
                                      location: Location(latitude: 44.84044, longitude: -0.5805),
                                      pictures: [Picture(squares32: "image2@32x32.png",
                                                         squares64: "image2@64x64.png",
                                                         squares128: "image2@128x128.png")]),
                        AdListingData(_id: "669321687",
                                      title: "Test Item 3",
                                      creationDateMs: fiveDaysAgo,
                                      location: Location(latitude: 44.84044, longitude: -0.5805),
                                      pictures: [Picture(squares32: "image3@32x32.png",
                                                         squares64: "image3@64x64.png",
                                                         squares128: "image3@128x128.png")])]

        let models = mapper.map(response: response)

        XCTAssertEqual(models[0].postedTime, "10min")
        XCTAssertEqual(models[1].postedTime, "2h")
        XCTAssertEqual(models[2].postedTime, "5d")
    }

    func testFormatDistance() {
        let closeLocation = Location(latitude: 44.836151, longitude: -0.580816)
        let farLocation = Location(latitude: 45.0, longitude: -1.0)

        let response = [AdListingData(_id: "123456789",
                                      title: "Test Item 1",
                                      creationDateMs: Int64(Date().timeIntervalSince1970 - 600),
                                      location: closeLocation,
                                      pictures: [Picture(squares32: "image1@32x32.png",
                                                         squares64: "image1@64x64.png",
                                                         squares128: "image1@128x128.png")]),
                        AdListingData(_id: "654987982",
                                      title: "Test Item 2",
                                      creationDateMs: Int64(Date().timeIntervalSince1970 - 3600),
                                      location: farLocation,
                                      pictures: [Picture(squares32: "image2@32x32.png",
                                                         squares64: "image2@64x64.png",
                                                         squares128: "image2@128x128.png")])]

        let models = mapper.map(response: response)

        XCTAssertEqual(models[0].distance, "0m")
        XCTAssertEqual(models[1].distance, "37km")
    }
}
