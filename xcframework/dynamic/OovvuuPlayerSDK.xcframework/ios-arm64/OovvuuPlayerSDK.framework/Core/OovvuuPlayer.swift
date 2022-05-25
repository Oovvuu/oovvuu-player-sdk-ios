//
//  OovvuuPlayer.swift
//  OovvuuSDK
//
//  Created by Alex Nazarov on 16/5/2022.
//

import Foundation
import UIKit

public protocol OovvuuPlayerProtocol {
    static func getSinglePlayerView(config: OovvuuConfig) -> UIView
}

public class OovvuuPlayer: OovvuuPlayerProtocol {
    
    static func getSinglePlayerView(config: OovvuuConfig) -> UIView {
        SinglePlayerViewController(config: config).view
    }
}
