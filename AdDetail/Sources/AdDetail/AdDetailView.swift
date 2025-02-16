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

    public init(viewModel: AdDetailViewModel) {
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

    private func bindViewModel() {
        bindDetails()
        bindImage()
        bindError()
    }

    private func bindDetails() {
        viewModel.adDetailSubject
            .subscribe(onNext: { [weak self] detail in
                self?.titleLabel.text = detail.title
                self?.summaryLabel.text = detail.summary
            })
            .disposed(by: disposeBag)
    }

    private func bindImage() {
        viewModel.imageSubject
            .subscribe(onNext: { [weak self] image in
                self?.imageView.image = image
                self?.contactButton.isHidden = false
            })
            .disposed(by: disposeBag)
    }

    private func bindError() {
        viewModel.errorSubject
            .subscribe(onNext: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }

    private func setupView() {
        view.backgroundColor = .lightGray
        setupImageView()
        setupButton()
        setupTitleLabel()
        setupSummaryLabel()
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(imageView.snp.width)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
        }
    }

    private func setupButton() {
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.contentInsets = .init(top: 8, leading: 12, bottom: 8, trailing: 12)

        contactButton.configuration = buttonConfiguration
        contactButton.setTitle("Soyez le 1er à contacter", for: .normal)
        contactButton.backgroundColor = .white
        contactButton.setTitleColor(.black, for: .normal)
        contactButton.layer.cornerRadius = 4
        imageView.addSubview(contactButton)
        contactButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(20)
        }
        contactButton.isHidden = true
    }

    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(imageView.snp.bottom).offset(16)
        }
    }

    private func setupSummaryLabel() {
        view.addSubview(summaryLabel)
        summaryLabel.font = .systemFont(ofSize: 22, weight: .regular)
        summaryLabel.numberOfLines = 0
        summaryLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
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
