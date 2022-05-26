//
//  Video.swift
//  OovvuuSDK
//
//  Created by Sergey Klimusha on 6/4/2022.
//

import Foundation

struct Video: Codable {
    var provider: Provider
    var id: Int64
    var title: String
    var providerAssetId: String
    var description: String
    var genres: [String]
    var thumbnail: String
    var duration: Int64
    var publishedAt: Date
    var adTag: String
    var brightcoveVideoId: String
}
