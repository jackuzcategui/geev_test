// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct AdListingView: View {
    @StateObject var viewModel: AdListingViewModel

    public init(viewModel: AdListingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        Text(viewModel.ads.first?.value ?? "")
            .onAppear {
                Task {
                    await viewModel.viewDidLoad()
                }
            }
    }
}
