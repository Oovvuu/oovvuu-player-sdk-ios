//
//  PlayerState.swift
//  OovvuuSDK
//
//  Created by Sergey Klimusha on 15/4/2022.
//

import Foundation

enum PlayerState {
    case loading
    case success(OovvuuResponse)
    case error(Error?)
}
