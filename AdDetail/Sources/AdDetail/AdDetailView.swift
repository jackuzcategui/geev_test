//
//  AdDetailView.swift
//  AdDetail
//
//  Created by Jack Uzcategui on 15/02/2025.
//

import UIKit
import SnapKit
import RxSwift
import SwiftUI

public class AdDetailViewController: UIViewController {
    private var viewModel: AdDetailViewModel
    private let disposeBag = DisposeBag()

    private let loadingView = UIActivityIndicatorView(style: .medium)
    private let imageView = UIImageView(frame: .zero)
    private let titleLabel = UILabel()
    private let summaryLabel = UILabel()
    private let contactButton = UIButton(frame: .zero)

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: AdDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bindViewModel()

        Task {
            await viewModel.viewAppeared()
        }
    }

    private func setupView() {

    }

    private func bindViewModel() {
        viewModel.adDetailSubject
            .subscribe(onNext: { detail in
                print(detail)
            })
            .disposed(by: disposeBag)

        viewModel.errorSubject
            .subscribe(onNext: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}

public struct AdDetailViewControllerRepresentable: UIViewControllerRepresentable {
    let viewModel: AdDetailViewModel

    public init(viewModel: AdDetailViewModel) {
        self.viewModel = viewModel
    }

    public func makeUIViewController(context: Context) -> AdDetailViewController {
        return AdDetailViewController(viewModel: viewModel)
    }

    public func updateUIViewController(_ uiViewController: AdDetailViewController, context: Context) {
        //
    }
}
