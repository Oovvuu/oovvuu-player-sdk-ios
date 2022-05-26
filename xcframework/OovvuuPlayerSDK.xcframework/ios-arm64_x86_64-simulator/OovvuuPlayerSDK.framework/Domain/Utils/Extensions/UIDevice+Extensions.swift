//
//  UIDevice+Extensions.swift
//  OovvuuSDK
//
//  Created by Alex Nazarov on 27/4/2022.
//

import UIKit

extension UIDevice {
    var modelName: String {
        var sysinfo = utsname()
        uname(&sysinfo)
        return String(cString: &sysinfo.machine.0)
    }
}
