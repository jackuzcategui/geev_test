// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct AdListingView: View {
    @StateObject var viewModel: AdListingViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    public init(viewModel: AdListingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
        case .display(let ads):
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(ads, id: \.id) {
                        AdGridItem(ad: $0)
                    }
                }
                .padding(.top, 10)
            }
            .scrollIndicators(.hidden)
        }
    }
}

struct AdGridItem: View {
    let ad: AdModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: ad.imageURL)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(ad.title)
                    .font(.headline)
                    .lineLimit(2)
            }
            .padding([.horizontal, .bottom], 8)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}
