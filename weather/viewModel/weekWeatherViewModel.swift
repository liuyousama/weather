//
//  weekWeatherViewModel.swift
//  weather
//
//  Created by 六游 on 2020/4/10.
//  Copyright © 2020 六游. All rights reserved.
//

import UIKit

struct WeekWeatherViewModel {
    var weekWeatherData:WeekForecastData? {
        didSet {
            if let _ = self.weekWeatherData {
                self.isDataReady = true
            } else {
                self.isDataReady = false
            }
        }
    }
    
    var isDataReady = false
    // MARK: - 对外提供的属性
    var dataCount:Int {
        weekWeatherData?.data.count ?? 0
    }
    var sectionCount:Int {
        return 1
    }
    
    func week(for index:Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: weekWeatherData?.data[index].time ?? Date.init(timeIntervalSinceNow: 0))
    }
    func time(for index:Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter.string(from: weekWeatherData?.data[index].time ?? Date.init(timeIntervalSinceNow: 0))
    }
    func forecastTemperature(for index:Int) -> String {
        let low = weekWeatherData?.data[index].temperatureLow.toCelsiusStr() ?? "Unknown"
        let high = weekWeatherData?.data[index].temperatureHigh.toCelsiusStr() ?? "Unknown"
        
        return "\(low) - \(high)"
    }
    func forecastHumidity(for index:Int) -> String {
        return weekWeatherData?.data[index].humidity.toHumiditStr() ?? "Unknown"
    }
    func icon(for index:Int) -> UIImage? {
        let icon = weekWeatherData?.data[index].icon ?? "clear"
        return UIImage.getWeatherIcon(withIconName: icon)
    }
    
    
    
}
