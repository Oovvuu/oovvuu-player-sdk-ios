//
//  Bundle+Extensions.swift
//  OovvuuSDK
//
//  Created by Alex Nazarov on 27/4/2022.
//

import Foundation

extension Bundle {
    static func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        if let version : String = dictionary["CFBundleName"] as? String {
            return version
        } else {
            return ""
        }
    }
    
    static func appVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        if let version : String = dictionary["CFBundleShortVersionString"] as? String {
            return version
        } else {
            return ""
        }
    }
    
}
