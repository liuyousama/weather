//
//  UIImage+Extensions.swift
//  weather
//
//  Created by 六游 on 2020/4/9.
//  Copyright © 2020 六游. All rights reserved.
//

import UIKit

extension UIImage {
    static func getWeatherIcon(withIconName iconName:String) -> UIImage? {
        if let img = UIImage(named: iconName) {
            return img
        } else {
            return UIImage(named: "clear-day")
        }
    }
}
