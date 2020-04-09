//
//  Weather.swift
//  weather
//
//  Created by 六游 on 2020/4/8.
//  Copyright © 2020 六游. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let latitude:Double
    let longitude:Double
    
    let currently:CurrentWeather

    
}

struct CurrentWeather: Codable {
    let time:Date
    let summary:String
    let icon:String
    let temperature:Double
    let humidity:Double
}
