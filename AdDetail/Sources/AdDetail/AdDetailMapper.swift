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
            imageURL: getImagePath(picture: response.pictures.first),
            title: response.title,
            summary: response.description
        )
    }

    func getImagePath(picture: String?) -> String {
        guard let picture = picture else {
            return ""
        }
        return "https://images.geev.fr/\(picture)/squares/600"
    }
}
