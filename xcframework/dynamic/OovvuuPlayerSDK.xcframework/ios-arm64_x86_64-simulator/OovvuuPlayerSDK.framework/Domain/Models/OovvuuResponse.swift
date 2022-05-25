//
//  Response.swift
//  OovvuuSDK
//
//  Created by Sergey Klimusha on 6/4/2022.
//

import Foundation

struct OovvuuResponse: Codable {
    var brightcove: Brightcove
    var videos: [Video]
    var options: Options
}
