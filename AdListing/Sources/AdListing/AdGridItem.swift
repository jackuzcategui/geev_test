//
//  AdGridItem.swift
//  AdListing
//
//  Created by Jack Uzcategui on 18/02/2025.
//

import SwiftUI

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
                Spacer(minLength: 32)
                HStack (spacing: 4) {
                    Image(systemName: "clock")
                            .font(.system(size: 10))
                    Text(ad.postedTime)
                        .padding(.trailing, 16)
                    Image(systemName: "location")
                            .font(.system(size: 10))
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
