//
//  AdDetailViewModel.swift
//  AdDetail
//
//  Created by Jack Uzcategui on 15/02/2025.
//

import SwiftUI
import RxSwift

@MainActor
public class AdDetailViewModel: ObservableObject {
    public enum State {
        case loading
        case error(String)
        case display
    }

    @Published public var state: State = .loading
    @Published var detail: AdDetailModel?

    let adDetailSubject = PublishSubject<AdDetailModel>()
    let errorSubject = PublishSubject<String>()
    private let disposeBag = DisposeBag()

    private let service: AdDetailServiceProtocol
    private let id: String

    public init(service: AdDetailServiceProtocol, id: String) {
        self.service = service
        self.id = id
    }

    public func viewAppeared() async {
        guard case .loading = state else { return }
        state = .loading
        await fetchDetail()
    }

    private func fetchDetail() async {
        do {
            detail = try await self.service.fetchDetail(id: id)
            state = .display
            adDetailSubject.onNext(detail!)
        } catch {
            state = .error(error.localizedDescription)
            errorSubject.onNext(error.localizedDescription)
        }
    }
}
