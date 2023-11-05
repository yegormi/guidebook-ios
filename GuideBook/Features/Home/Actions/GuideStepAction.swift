//
//  GuideStepAction.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 01.11.2023.
//

import Foundation

struct GuideStepAction {
    let id: String
    let token: String

    func call(completion: @escaping (Result<[GuideStep], ErrorResponse>) -> Void) {
        NetworkManager.performRequest(
            baseURL: "https://guidebook-api.azurewebsites.net",
            endpoint: "/guide/\(id)/steps",
            requestType: .get,
            token: token,
            decodedBody: nil,
            completion: completion
        )
    }
}
