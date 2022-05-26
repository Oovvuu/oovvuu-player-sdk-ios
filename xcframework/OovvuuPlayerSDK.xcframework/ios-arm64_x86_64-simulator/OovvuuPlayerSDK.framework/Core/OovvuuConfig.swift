//
//  OouuvvConfig.swift
//  OovvuuSDK
//
//  Created by Alex Nazarov on 13/5/2022.
//

public struct OovvuuConfig {
    
    let hrefKey: String
    let appId: String
    let embedId: String
    let apiKey: String
    
    #if targetEnvironment(simulator)
    init() {
        hrefKey = "https://www.news24.com/news24/world/news/six-countries-urge-eu-to-continue-afghan-deportations-20210810"
        appId = "Y29tLm9vdnZ1dS5zZGsuaW9zLnRlc3RhcHA="
        embedId = "12345678-1234-1234-1234-12345678"
        apiKey = "OOVVUU_PLAYBACK_API_KEY"
    }
    #endif
}
