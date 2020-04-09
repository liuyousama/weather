//
//  Double+Extensions.swift
//  weather
//
//  Created by 六游 on 2020/4/9.
//  Copyright © 2020 六游. All rights reserved.
//

import Foundation

extension Double {
    public func toCelsiusStr() -> String {
        let celsius = (self-32.0)/1.8
        return String(format: "%.1f℃", celsius)
    }
    
    public func toHumiditStr() -> String {
        let humidity = self * 100
        return String(format: "%.1f", humidity)+"%"
    }
}
