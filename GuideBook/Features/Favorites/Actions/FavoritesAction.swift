//
//  FavoritesAction.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 31.10.2023.
//

import Foundation

struct FavoritesAction {
    let token: String
    
    func call(completion: @escaping (Result<[Guide], ErrorResponse>) -> Void) {
        NetworkManager.performRequest(
            baseURL: "https://guidebook-api.azurewebsites.net",
            endpoint: "/search/favorite/guides",
            requestType: .get,
            token: token,
            decodedBody: nil,
            completion: completion
        )
    }
}
