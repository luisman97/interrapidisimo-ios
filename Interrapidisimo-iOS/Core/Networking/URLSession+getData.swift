//
//  URLSession+getData.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import Foundation

extension URLSession {

    func getData(for request: URLRequest) async throws(NetworkError) -> (
        data: Data,
        response: HTTPURLResponse
    ) {
        do {
            let (data, response) = try await data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.nonHTTP
            }
            return (data, httpResponse)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw .general(error)
        }
    }
}
