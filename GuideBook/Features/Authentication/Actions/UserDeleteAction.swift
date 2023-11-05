//
//  UserDeleteAction.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 30.10.2023.
//

import Foundation

struct UserDeleteAction {
    let token: String

    func call(completion: @escaping (Result<UserDeleteResponse, ErrorResponse>) -> Void) {
        NetworkManager.performRequest(
            baseURL: "https://guidebook-api.azurewebsites.net",
            endpoint: "/auth/me",
            requestType: .delete,
            token: token,
            decodedBody: nil,
            completion: completion
        )
    }
}
