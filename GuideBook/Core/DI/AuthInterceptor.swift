//
//  AuthInterceptor.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 04.03.2024.
//

import Foundation
import Alamofire

struct AuthInterceptor: RequestInterceptor {
    private let tokenProvider: () -> String?

    init(tokenProvider: @escaping () -> String?) {
        self.tokenProvider = tokenProvider
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var modifiedRequest = urlRequest

        if let token = tokenProvider() {
            modifiedRequest.setValue("\(token)", forHTTPHeaderField: "Authorization")
        }

        completion(.success(modifiedRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        // Handle retry logic if needed
        completion(.doNotRetry)
    }
}
