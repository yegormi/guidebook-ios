//
//  GuideAction.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 29.10.2023.
//

import Foundation

struct GuideAction {
    let token: String
    
    func call(completion: @escaping (Result<[Guide], ErrorResponse>) -> Void) {
        NetworkManager.performRequest(
            baseURL: "https://guidebook-api.azurewebsites.net",
            endpoint: "/guides",
            requestType: .get,
            token: token,
            decodedBody: nil,
            completion: completion
        )
    }
}
