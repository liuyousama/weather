//
//  WeekWeatherViewModel.swift
//  weather
//
//  Created by 六游 on 2020/4/21.
//  Copyright © 2020 六游. All rights reserved.
//

import Foundation
import UIKit

struct WeekWeatherViewModel {
    var weathers:WeekForecastData
    
    static let empty = WeekWeatherViewModel(weathers: WeekForecastData.empty)
    
    var isEmpty:Bool {
        return self.weathers == WeekForecastData.empty
    }
}

// MARK: - 对外提供的用于未来七天预报的属性
extension WeekWeatherViewModel: WeekWeatherRepresenter {
    var dataCount:Int {
        weathers.data.count
    }
    var sectionCount:Int {
        return 1
    }
    
    func week(for index:Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: weathers.data[index].time)
    }
    func time(for index:Int) -> String {
        let formatter = DateFormatter()
        let timeMode = SettingHelper.getDateMode()
        switch timeMode {
        case .text:
            formatter.dateFormat = "MMMM d"
        case .digit:
            formatter.dateFormat = "MM/dd"
        }
        return formatter.string(from: weathers.data[index].time)
    }
    func forecastTemperature(for index:Int) -> String {
        let temMode = SettingHelper.getTemperatureMode()
        let low = temMode.temperatureText(weathers.data[index].temperatureLow)
        let high = temMode.temperatureText(weathers.data[index].temperatureHigh)
        
        return "\(low) - \(high)"
    }
    func forecastHumidity(for index:Int) -> String {
        return weathers.data[index].humidity.toHumiditStr()
    }
    func icon(for index:Int) -> UIImage? {
        let icon = weathers.data[index].icon
        return UIImage.getWeatherIcon(withIconName: icon)
    }
}


protocol WeekWeatherRepresenter {
    var dataCount:Int { get }
    var sectionCount:Int { get }
    /// 位于index处的cell的周文字
    func week(for index:Int) -> String
    
    func time(for index:Int) -> String
    
    func forecastTemperature(for index:Int) -> String
    
    func forecastHumidity(for index:Int) -> String
    
    func icon(for index:Int) -> UIImage?
}
