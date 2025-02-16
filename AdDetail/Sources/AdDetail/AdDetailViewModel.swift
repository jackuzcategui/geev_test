//
//  AdDetailViewModel.swift
//  AdDetail
//
//  Created by Jack Uzcategui on 15/02/2025.
//

import SwiftUI
import RxSwift

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
    let imageSubject = PublishSubject<UIImage?>()
    private let disposeBag = DisposeBag()

    private let service: AdDetailServiceProtocol
    private let id: String

    public init(service: AdDetailServiceProtocol, id: String) {
        self.service = service
        self.id = id
    }

    @MainActor
    public func viewAppeared() async {
        guard case .loading = state else { return }
        state = .loading
        await fetchDetail()
    }

    @MainActor
    private func fetchDetail() async {
        do {
            detail = try await self.service.fetchDetail(id: id)
            state = .display
            adDetailSubject.onNext(detail!)
            if let path = detail?.imageURL {
                fetchImage(path: path)
            }
        } catch {
            state = .error(error.localizedDescription)
            errorSubject.onNext(error.localizedDescription)
        }
    }

    private func fetchImage(path: String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let url = URL(string: path), let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.imageSubject.onNext(nil)
                }
                return
            }
            DispatchQueue.main.async {
                self?.imageSubject.onNext(image)
            }
        }
    }
}
