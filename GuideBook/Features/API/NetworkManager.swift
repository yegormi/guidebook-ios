//
//  NetworkManager.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 30.10.2023.
//

import Foundation

struct NetworkManager {
    static func performRequest<T: Codable>(
        baseURL: String,
        endpoint: String,
        requestType: RequestType,
        token: String? = nil,
        decodedBody: Codable? = nil,
        completion: @escaping (Result<T, ErrorResponse>) -> Void
    ) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(ErrorResponse(code: "400", message: "Invalid URl")))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue

        if let token {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }

        if let decodedBody {
            do {
                request.httpBody = try JSONEncoder().encode(decodedBody)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(ErrorResponse(code: "400", message: "Invalid HTTP Body")))
                return
            }
        }
        request.cachePolicy = .reloadRevalidatingCacheData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(ErrorResponse(code: "1000", message: "The request timed out")))
                return
            }

            guard let data,
                  let httpResponse = response as? HTTPURLResponse,
                  (200 ... 299).contains(httpResponse.statusCode)
            else {
                let httpResponse = response as? HTTPURLResponse
                print("HTTP Response: \(httpResponse?.statusCode ?? 1)")
                if let data {
                    do {
                        let response = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        completion(.failure(response))
                    } catch {
                        completion(.failure(ErrorResponse(code: "400", message: "Invalid ErrorResponse")))
                    }
                }
                return
            }

            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(ErrorResponse(code: "400", message: "Failed to parse response")))
            }
        }
        task.resume()
    }
}
