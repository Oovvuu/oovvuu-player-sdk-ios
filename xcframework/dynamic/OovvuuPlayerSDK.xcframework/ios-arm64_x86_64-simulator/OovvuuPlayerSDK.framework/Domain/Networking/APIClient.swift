//
//  APIClient.swift
//  OovvuuSDK
//
//  Created by Sergey Klimusha on 7/4/2022.
//

import Foundation

struct APIClient {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func requestData<T: APIRequest>(request: T, completion: @escaping (Result<T.Response, Error>) -> Void) {
        let url = request.url
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        urlRequest.allHTTPHeaderFields = request.headers
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                // Handle HTTP request error
                completion(.failure(error))
            } else if let responseData = data {
                // Handle HTTP request response
                do {
                    let decodedResponse = try request.handle(response: responseData)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
