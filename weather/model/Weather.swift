//
//  Weather.swift
//  weather
//
//  Created by 六游 on 2020/4/8.
//  Copyright © 2020 六游. All rights reserved.
//

import Foundation

struct WeatherData: Codable, Equatable {
    let latitude:Double
    let longitude:Double
    
    let currently:CurrentWeather
    let daily:WeekForecastData
    
    static let empty = WeatherData(latitude: 0, longitude: 0, currently: CurrentWeather.empty, daily: WeekForecastData.empty)
}

struct CurrentWeather: Codable, Equatable {
    let time:Date
    let summary:String
    let icon:String
    let temperature:Double
    let humidity:Double
    
    static let empty = CurrentWeather(time: Date(), summary: "", icon: "", temperature: 0, humidity: 0)
}

struct WeekForecastData: Codable, Equatable {
    let data:[DailyForecastData]
    
    static let empty = WeekForecastData(data: [])
}

struct DailyForecastData: Codable, Equatable {
    let time:Date
    let temperatureLow:Double
    let temperatureHigh:Double
    let icon:String
    let humidity:Double
}
