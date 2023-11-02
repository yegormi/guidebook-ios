//
//  UserInfoAction.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 28.10.2023.
//

import Foundation

struct UserInfoAction {
    let token: String
    
    func call(completion: @escaping (Result<UserInfoResponse, ErrorResponse>) -> Void) {
        NetworkManager.performRequest(
            baseURL: "https://guidebook-api.azurewebsites.net",
            endpoint: "/auth/me",
            requestType: .get,
            token: token,
            decodedBody: nil,
            completion: completion
        )
    }
}
