//
//  OovvuuRequest.swift
//  OovvuuSDK
//
//  Created by Sergey Klimusha on 6/4/2022.
//

import Foundation

struct OovvuuRequest: APIRequest {
    typealias Response = OovvuuResponse
    
    private let appId: String
    private let embedId: String
    private let apiKey: String
    private let appVersion = Bundle.appVersion()
    
    init(appId: String, embedId: String, apiKey: String) {
        self.appId = appId
        self.embedId = embedId
        self.apiKey = apiKey
    }
    
    var method: HTTPMethod { .GET }
    var url: URL { getURL() }
    var body: Data?
    var headers: [String: String] { getHeaders() }
    
    func handle(response: Data) throws -> OovvuuResponse {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Response.self, from: response)
    }
    
    private func getURL() -> URL {
        URL(string:"https://playback.staging.oovvuu.lol/m/embed/\(appId)/\(embedId)")!
    }
    
    private func getHeaders() -> [String: String] {
        ["x-api-key": apiKey, "x-oovvuu-app": "oovvuu-ios-sdk/\(appVersion)"]
    }

}
