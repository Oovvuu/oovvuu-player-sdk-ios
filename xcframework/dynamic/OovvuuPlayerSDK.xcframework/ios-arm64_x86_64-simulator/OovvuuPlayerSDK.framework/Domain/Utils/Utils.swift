//
//  Utils.swift
//  OovvuuSDK
//
//  Created by Alex Nazarov on 27/4/2022.
//

import Foundation
import MapKit
import WebKit

class Utils {
    
    static func getGeolocation() -> CLLocation? {
        let locationManager = CLLocationManager()
        switch locationManager.authorizationStatus {
        case .authorizedAlways , .authorizedWhenInUse:
            guard let latitude = locationManager.location?.coordinate.latitude,
                  let longitude = locationManager.location?.coordinate.longitude else {
                return nil
            }
            return CLLocation(latitude: latitude, longitude: longitude)
        default:
            return nil
        }
    }
    
    static func getUserAgent() -> String {
        String(describing: WKWebView().value(forKey: "userAgent") ?? "")
    }
}
