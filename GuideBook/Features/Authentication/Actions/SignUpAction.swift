//
//  SignUpAction.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 28.10.2023.
//

import Foundation

struct SignUpAction {
    var parameters: SignUpRequest

    func call(completion: @escaping (Result<AuthResponse, ErrorResponse>) -> Void) {
        NetworkManager.performRequest(
            baseURL: "https://guidebook-api.azurewebsites.net",
            endpoint: "/auth/signup",
            requestType: .post,
            token: nil,
            decodedBody: parameters,
            completion: completion
        )
    }
}
