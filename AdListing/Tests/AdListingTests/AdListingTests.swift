//
//  AdListingViewModelTests.swift
//  AdListing
//
//  Created by Jack Uzcategui on 14/02/2025.
//

import XCTest
@testable import AdListing

final class AdListingViewModelTests: XCTestCase {

    private var viewModel: AdListingViewModel!
    private var mockService: MockAdListingService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockService = MockAdListingService()
        viewModel = AdListingViewModel(service: mockService)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockService = nil
        try super.tearDownWithError()
    }

    func testInitialStateIsLoading() {
        XCTAssertEqual(viewModel.state, .loading)
    }

    @MainActor
    func testViewAppearedWithEmptyAds() async {
        mockService.mockAds = []
        await viewModel.viewAppeared()
        XCTAssertEqual(viewModel.state, .empty)
    }

    @MainActor
    func testViewAppearedWithAds() async {
        let ads = [AdModel(id: "321654987",
                           imageURL: "image1.png",
                           title: "Test Item 1",
                           postedTime: "1h",
                           distance: "4km"),
                   AdModel(id: "561423189",
                           imageURL: "image2.png",
                           title: "Test Item 2",
                           postedTime: "3h",
                           distance: "600m")]
        mockService.mockAds = ads
        await viewModel.viewAppeared()
        XCTAssertEqual(viewModel.state, .display)
    }

    @MainActor
    func testViewAppearedWithError() async {
        mockService.shouldThrowError = true
        await viewModel.viewAppeared()
        if case .error(let message) = viewModel.state {
            XCTAssertEqual(message, "Failed to fetch ads")
        } else {
            XCTFail("State should be .error")
        }
    }

    @MainActor
    func testDidDisplayLastItemLoadMore() async {
        let ads = [AdModel(id: "321654987",
                           imageURL: "image1.png",
                           title: "Test Item 1",
                           postedTime: "1h",
                           distance: "4km"),
                   AdModel(id: "561423189",
                           imageURL: "image2.png",
                           title: "Test Item 2",
                           postedTime: "3h",
                           distance: "600m")]
        mockService.mockAds = ads
        await viewModel.viewAppeared()
        XCTAssertEqual(viewModel.state, .display)
        XCTAssertEqual(viewModel.ads.count, 2)

        mockService.mockAds = [AdModel(id: "545564469",
                                       imageURL: "image3.png",
                                       title: "Test Item 3",
                                       postedTime: "45m",
                                       distance: "900m")]
        await viewModel.didDisplayLastItem()
        XCTAssertEqual(viewModel.ads.count, 3)
    }
}

public final class MockAdListingService: AdListingServiceProtocol {
    @MainActor var mockAds: [AdModel] = []
    @MainActor var shouldThrowError = false

    public func fetchAds(page: String?) async throws -> [AdModel] {
        if await shouldThrowError {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch ads"])
        }
        return await mockAds
    }
}
