//
//  APIRequest.swift
//  OovvuuSDK
//
//  Created by Sergey Klimusha on 6/4/2022.
//

import Foundation

protocol APIRequest {
    associatedtype Response
    
    var method: HTTPMethod { get }
    var url: URL { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    
    func handle(response: Data) throws -> Response
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
}
