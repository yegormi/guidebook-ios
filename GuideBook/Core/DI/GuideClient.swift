//
//  GuideClient.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 28.11.2023.
//

import Alamofire
import ComposableArchitecture
import Foundation

@DependencyClient
struct GuideClient {
    var searchGuides: @Sendable (_ token: String, _ query: String) async throws -> [Guide]
    var searchFavorites: @Sendable (_ token: String, _ query: String) async throws -> [Guide]
}

extension DependencyValues {
    var guideClient: GuideClient {
        get { self[GuideClient.self] }
        set { self[GuideClient.self] = newValue }
    }
}

extension GuideClient {
    static let baseUrl = Helpers.baseUrl
}

extension GuideClient: DependencyKey, TestDependencyKey {
    
    /// Live implementation for production use
    static let liveValue = Self(
        searchGuides: { token, query in
            let endpoint = "/guides"
            
            let parameters: Parameters  = [
                "query": "\(query)",
            ]
            
            let headers: HTTPHeaders = [
                "Authorization": "\(token)"
            ]
            
            return try await withCheckedThrowingContinuation { continuation in
                AF.request(baseUrl + endpoint,
                           method: .get,
                           parameters: parameters,
                           headers: headers
                )
                .validate()
                .responseDecodable(of: [Guide].self) { response in
                    handleResponse(response, continuation)
                }
            }
        }, searchFavorites: { token, query in
            let endpoint = "/favorite/guides"
            
            let parameters: Parameters  = [
                "query": "\(query)",
            ]
            
            let headers: HTTPHeaders = [
                "Authorization": "\(token)"
            ]
            
            return try await withCheckedThrowingContinuation { continuation in
                AF.request(baseUrl + endpoint,
                           method: .get,
                           parameters: parameters,
                           headers: headers
                )
                .validate()
                .responseDecodable(of: [Guide].self) { response in
                    handleResponse(response, continuation)
                }
            }
        }
    )
    
    /// Test implementation with no-op functions
    static let testValue = Self()
}

// MARK: - Response Handling
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

