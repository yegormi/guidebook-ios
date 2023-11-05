//
//  FavoritesAddAction.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 31.10.2023.
//

import Foundation

struct FavoritesAddAction {
    let id: String
    let token: String

    func call(completion: @escaping (Result<SuccessResponse, ErrorResponse>) -> Void) {
        NetworkManager.performRequest(
            baseURL: "https://guidebook-api.azurewebsites.net",
            endpoint: "/favorite/guides/\(id)",
            requestType: .put,
            token: token,
            decodedBody: nil,
            completion: completion
        )
    }
}
