//
//  OovvuuRequest.swift
//  OovvuuSDK
//
//  Created by Alex Nazarov on 6/4/2022.
//

import Foundation

struct AnalyticsRequest: APIRequest {
    
    public enum AnalyticsEvent: String {
        case playVideo = "video_play"
        case loadedVideo = "video_load"
        case loadedEmbed = "embed_load"
    }
    typealias Response = AnalyticsResponse
    
    private let videoId: String?
    private let embedId: String
    private let playerId: String
    private let hrefKey: String
    private let event: AnalyticsEvent
    
    init(embedId: String, videoId: String, playerId: String, hrefKey: String, event: AnalyticsEvent) {
        self.videoId = videoId
        self.embedId = embedId
        self.playerId = playerId
        self.hrefKey = hrefKey
        self.event = event
    }
    
    var method: HTTPMethod { .GET }
    var url: URL { getURL() }
    var body: Data?
    var headers: [String: String] { getHeaders() }
    
    func handle(response: Data) throws -> AnalyticsResponse {
        return try JSONDecoder().decode(Response.self, from: response)
    }
    
    private func getURL() -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "playback.staging.oovvuu.lol"
        components.path = "/m/notify/\(embedId)"

        components.queryItems = [
            URLQueryItem(name: "e", value: event.rawValue),
            URLQueryItem(name: "v", value: videoId),
            URLQueryItem(name: "p", value: playerId),
            URLQueryItem(name: "u", value: hrefKey)
        ]
        return components.url!
    }
    
    private func getHeaders() -> [String: String] {
        [:]
    }

}
