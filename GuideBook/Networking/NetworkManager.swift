//
//  NetworkManager.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 06.11.2023.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    func performRequest<T: Codable>(
        baseURL: String,
        endpoint: String,
        method: RequestType,
        token: String? = nil,
        decodedBody: Codable? = nil
    ) async throws -> T {
        
        guard let url = URL(string: baseURL + endpoint) else {
            throw ErrorResponse(code: "400", message: "Invalid URl")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let token = token {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        let encoder = JSONEncoder()
        if let decodedBody = decodedBody {
            do {
                request.httpBody = try encoder.encode(decodedBody)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw ErrorResponse(code: "400", message: "Invalid HTTP Body")
            }
        }
        
        request.cachePolicy = .reloadRevalidatingCacheData
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Response Data (non-JSON): \(String(data: data, encoding: .utf8) ?? "No data")")
                throw ErrorResponse(code: "404", message: "Invalid HTTP Response")
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch {
                print("Failed to parse response data as JSON: \(error)")
                let responseString = String(data: data, encoding: .utf8) ?? "No data"
                print("Response Data (non-JSON): \(responseString)")
                throw error
            }
        } catch {
            print("Network request error: \(error)")
            throw error
        }
        
    }
}
