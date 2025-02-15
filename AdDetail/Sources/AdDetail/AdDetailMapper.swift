//
//  AdDetailMapper.swift
//  AdDetail
//
//  Created by Jack Uzcategui on 15/02/2025.
//

class AdDetailMapper {
    func map(response: AdDetailResponse) -> AdDetailModel {
        AdDetailModel(
            id: response._id,
            imageURL: "https://images.geev.fr/\(response.pictures.first ?? "")/resizes/1000",
            title: response.title,
            summary: response.description
        )
    }
}
