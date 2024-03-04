//
//  GuideClient.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 28.11.2023.
//

import Alamofire
import ComposableArchitecture
import Foundation

// MARK: - API client interface

// Typically this interface would live in its own module, separate from the live implementation.
// This allows the search feature to compile faster since it only depends on the interface.

@DependencyClient
struct GuideClient {
    var searchGuides: @Sendable (_ query: String) async throws -> [Guide]
    var searchFavorites: @Sendable (_ query: String) async throws -> [Guide]
    var getDetails: @Sendable (_ id: String) async throws -> GuideDetails
    var getSteps: @Sendable (_ id: String) async throws -> [GuideStep]
    var addToFavorites: @Sendable (_ id: String) async throws -> ResponseMessage
    var deleteFromFavorites: @Sendable (_ id: String) async throws -> ResponseMessage
}

extension DependencyValues {
    var guideClient: GuideClient {
        get { self[GuideClient.self] }
        set { self[GuideClient.self] = newValue }
    }
}

// MARK: - Live API implementation

extension GuideClient: DependencyKey, TestDependencyKey {
    @Dependency(\.sessionClient) static var sessionClient
    static let session = sessionClient.current
    
    static let liveValue = GuideClient(
        searchGuides: { query in
            let endpoint = "/guides"
            
            let parameters: Parameters = [
                "query": "\(query)",
            ]
            
            return try await withCheckedThrowingContinuation { continuation in
                session.request(baseUrl + endpoint,
                           method: .get,
                           parameters: parameters)
                .validate()
                .responseDecodable(of: [Guide].self) { response in
                    handleResponse(response, continuation)
                }
            }
        }, searchFavorites: {query in
            let endpoint = "/favorite/guides"
            
            let parameters: Parameters = [
                "query": "\(query)",
            ]
            
            return try await withCheckedThrowingContinuation { continuation in
                session.request(baseUrl + endpoint,
                           method: .get,
                           parameters: parameters)
                .validate()
                .responseDecodable(of: [Guide].self) { response in
                    handleResponse(response, continuation)
                }
            }
        }, getDetails: { id in
            let endpoint = "/guides/\(id)"
            
            return try await withCheckedThrowingContinuation { continuation in
                session.request(baseUrl + endpoint,
                           method: .get)
                .validate()
                .responseDecodable(of: GuideDetails.self) { response in
                    handleResponse(response, continuation)
                }
            }
        }, getSteps: { id in
            let endpoint = "/guides/\(id)/steps"
            
            return try await withCheckedThrowingContinuation { continuation in
                session.request(baseUrl + endpoint,
                           method: .get)
                .validate()
                .responseDecodable(of: [GuideStep].self) { response in
                    handleResponse(response, continuation)
                }
            }
        }, addToFavorites: { id in
            let endpoint = "/favorite/guides/\(id)"
            
            return try await withCheckedThrowingContinuation { continuation in
                session.request(baseUrl + endpoint,
                           method: .put)
                .validate()
                .responseDecodable(of: ResponseMessage.self) { response in
                    handleResponse(response, continuation)
                }
            }
        }, deleteFromFavorites: {id in
            let endpoint = "/favorite/guides/\(id)"
            
            return try await withCheckedThrowingContinuation { continuation in
                session.request(baseUrl + endpoint,
                           method: .delete)
                .validate()
                .responseDecodable(of: ResponseMessage.self) { response in
                    handleResponse(response, continuation)
                }
            }
        }
    )
}

// MARK: - Test Implementation

extension GuideClient {
    static let testValue = Self()
}

// MARK: - Helpers

extension GuideClient {
    static let baseUrl = Helpers.baseUrl
}

private func handleResponse<T>(_ response: AFDataResponse<T>, _ continuation: CheckedContinuation<T, Error>) {
    switch response.result {
    case let .success(value):
        continuation.resume(returning: value)
    case let .failure(error):
        if let data = response.data,
           let failResponse = try? JSONDecoder().decode(FailResponse.self, from: data)
        {
            continuation.resume(throwing: ErrorResponse.failedWithResponse(failResponse))
        } else {
            continuation.resume(throwing: error)
        }
    }
}
