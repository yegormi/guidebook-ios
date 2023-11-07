//
//  GuideDetailsAction.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 30.10.2023.
//

import Foundation

struct GuideDetailsAction {
    let id: String
    let token: String
    
    func call(completion: @escaping (Result<GuideDetails, ErrorResponse>) -> Void) {
        NetworkManager.performRequest(
            baseURL: "https://guidebook-api.azurewebsites.net",
            endpoint: "/guides/\(id)",
            requestType: .get,
            token: token,
            decodedBody: nil,
            completion: completion
        )
    }
}
