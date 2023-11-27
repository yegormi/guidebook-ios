//
//  GuideAPI.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 28.11.2023.
//

import Foundation
import Alamofire

class GuideAPI {
    static let shared = GuideAPI()
    
    let baseUrl = Helpers.baseUrl
    
    func fetchGuides(with token: String) async throws -> [Guide] {
        let endpoint = "/guides"
        
        let headers: HTTPHeaders = [
            "Authorization": "\(token)"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(baseUrl + endpoint,
                       method: .get,
                       headers: headers
            )
            .validate()
            .responseDecodable(of: [Guide].self) { response in
                self.handleResponse(response, continuation)
            }
        }
    }
    
    private func handleResponse<T>(_ response: AFDataResponse<T>, _ continuation: CheckedContinuation<T, Error>) {
        switch response.result {
        case .success(let value):
            continuation.resume(returning: value)
        case .failure(let error):
            if let data = response.data,
               let failResponse = try? JSONDecoder().decode(FailResponse.self, from: data) {
                continuation.resume(throwing: ErrorResponse.failedWithResponse(failResponse))
            } else {
                continuation.resume(throwing: error)
            }
        }
    }
}

