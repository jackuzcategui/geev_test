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
                .navigationTitle(Text("Ads"))
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

struct AdGridItem: View {
    let ad: AdModel

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: ad.imageURL)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(height: 200)
            .clipped()

            VStack(alignment: .leading) {
                Text(ad.title)
                    .font(.headline)
                    .lineLimit(2)
                HStack {
                    Text(ad.postedTime)
                    Spacer()
                    Text(ad.distance)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 20)
            .clipped()

            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
    }
}
