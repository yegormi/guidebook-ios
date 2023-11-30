//
//  GuideClient.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 28.11.2023.
//

import Foundation
import ComposableArchitecture
import Alamofire

// MARK: - API client interface

// Typically this interface would live in its own module, separate from the live implementation.
// This allows the search feature to compile faster since it only depends on the interface.

@DependencyClient
struct GuideClient {
    var searchGuides:    @Sendable (_ token: String, _ query: String) async throws -> [Guide]
    var searchFavorites: @Sendable (_ token: String, _ query: String) async throws -> [Guide]
    var getDetails:      @Sendable (_ token: String, _ id: String) async throws -> GuideDetails
    var getSteps:        @Sendable (_ token: String, _ id: String) async throws -> [GuideStep]
}

extension DependencyValues {
    var guideClient: GuideClient {
        get { self[GuideClient.self] }
        set { self[GuideClient.self] = newValue }
    }
}

// MARK: - Live API implementation

extension GuideClient: DependencyKey, TestDependencyKey {
    static let liveValue = GuideClient(
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
        }, getDetails: { token, id in
            let endpoint = "/guides/\(id)"
            
            let headers: HTTPHeaders = [
                "Authorization": "\(token)"
            ]
            
            return try await withCheckedThrowingContinuation { continuation in
                AF.request(baseUrl + endpoint,
                           method: .get,
                           headers: headers
                )
                .validate()
                .responseDecodable(of: GuideDetails.self) { response in
                    handleResponse(response, continuation)
                }
            }
        }, getSteps: { token, id in
            let endpoint = "/guides/\(id)/steps"
            
            let headers: HTTPHeaders = [
                "Authorization": "\(token)"
            ]
            
            return try await withCheckedThrowingContinuation { continuation in
                AF.request(baseUrl + endpoint,
                           method: .get,
                           headers: headers
                )
                .validate()
                .responseDecodable(of: [GuideStep].self) { response in
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

