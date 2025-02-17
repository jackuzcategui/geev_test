//
//  AdDetailViewModelTests.swift
//  AdListing
//
//  Created by Jack Uzcategui on 17/02/2025.
//


import XCTest
import RxSwift
@testable import AdDetail

final class AdDetailViewModelTests: XCTestCase {
    private var viewModel: AdDetailViewModel!
    private var service: MockAdDetailService!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        service = MockAdDetailService()
        viewModel = AdDetailViewModel(service: service, id: "test-id")
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        service = nil
        disposeBag = nil
        try super.tearDownWithError()
    }

    @MainActor
    func testViewAppearedSuccess() async {
        let expectedDetail = AdDetailModel(id: "1231564984",
                                           imageURL: "image1.png",
                                           title: "Test Item 1",
                                           summary: "Test description for Item 1")
        service.detailResult = .success(expectedDetail)

        await viewModel.viewAppeared()

        XCTAssertEqual(viewModel.state, .display)
        XCTAssertEqual(viewModel.detail?.id, expectedDetail.id)
        XCTAssertEqual(viewModel.detail?.title, expectedDetail.title)
    }

    @MainActor
    func testViewAppearedFailure() async {
        service.detailResult = .failure(NSError(domain: "TestError", code: -1, userInfo: nil))

        await viewModel.viewAppeared()

        XCTAssertEqual(viewModel.state, .error("The operation couldn’t be completed. (TestError error -1.)"))
        XCTAssertNil(viewModel.detail)
    }

    @MainActor
    func testAdDetailSubjectEmitsDetail() async {
        let expectedDetail = AdDetailModel(id: "1231564984",
                                           imageURL: "image1.png",
                                           title: "Test Item 1",
                                           summary: "Test description for Item 1")
        service.detailResult = .success(expectedDetail)
        let expectation = XCTestExpectation(description: "adDetailSubject should emit fetched detail")

        viewModel.adDetailSubject.subscribe(onNext: { detail in
            XCTAssertEqual(detail.id, expectedDetail.id)
            expectation.fulfill()
        }).disposed(by: disposeBag)

        await viewModel.viewAppeared()

        await fulfillment(of: [expectation], timeout: 2)
    }

    @MainActor
    func testErrorSubjectEmitsError() async {
        service.detailResult = .failure(NSError(domain: "TestError", code: -1, userInfo: nil))
        let expectation = XCTestExpectation(description: "errorSubject should emit an error")

        viewModel.errorSubject.subscribe(onNext: { error in
            XCTAssertEqual(self.viewModel.state, .error("The operation couldn’t be completed. (TestError error -1.)"))
            expectation.fulfill()
        }).disposed(by: disposeBag)

        await viewModel.viewAppeared()

        await fulfillment(of: [expectation], timeout: 2)
    }
}

public final class MockAdDetailService: AdDetailServiceProtocol {
    @MainActor var detailResult: Result<AdDetailModel, Error>!

    public func fetchDetail(id: String) async throws -> AdDetailModel {
        switch await detailResult {
        case .success(let detail):
            return detail
        case .failure(let error):
            throw error
        case .none:
            fatalError("detailResult must be set before calling fetchDetail")
        }
    }
}
