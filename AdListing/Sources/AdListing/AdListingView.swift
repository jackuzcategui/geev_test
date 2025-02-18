//
//  AdListingView.swift
//  AdListing
//
//  Created by Jack Uzcategui on 13/02/2025.
//

import SwiftUI
import Core

public struct AdListingView: View {
    @StateObject var viewModel: AdListingViewModel
    let coordinator: Coordinating

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    public init(viewModel: AdListingViewModel, coordinator: Coordinating) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }

    public var body: some View {
        NavigationView {
            content
                .task {
                    await viewModel.viewAppeared()
                }
                .refreshable {
                    await viewModel.viewAppeared(refresh: true)
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .error(let error):
            VStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                Text("Error: \(error)")
                    .font(.headline)
                    .foregroundColor(.red)
                Button("Retry") {
                    Task {
                        await viewModel.viewAppeared()
                    }
                }
                .padding()
                .background(Color.yellow)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .empty:
            VStack {
                Image(systemName: "tray")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                Text("There are no results for your query.")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .display:
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.ads, id: \.id) { item in
                        AdGridItem(ad: item)
                            .onAppear {
                                if item.id == viewModel.ads[max(0, viewModel.ads.count - 4)].id {
                                    Task {
                                        await viewModel.didDisplayLastItem()
                                    }
                                }
                            }
                            .onTapGesture {
                                coordinator.showAdDetail(adId: item.id)
                            }
                    }

                    if viewModel.isLoadingMore {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .padding(.horizontal, 16)
            }
            .background(Color.gray.opacity(0.2))
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    let service = AdListingServiceMock()
    let viewModel = AdListingViewModel(service: service)
    let coordinator = MockCoordinator()
    AdListingView(viewModel: viewModel, coordinator: coordinator)
}
