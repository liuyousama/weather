//
//  currentWeatherViewModel.swift
//  weather
//
//  Created by 六游 on 2020/4/9.
//  Copyright © 2020 六游. All rights reserved.
//

import UIKit

struct WeatherViewModel {
    var locationData:Location? {
        didSet {
            self.updateReadyStatus()
        }
    }
    var currentWeatherData:CurrentWeather? {
        didSet {
            self.updateReadyStatus()
        }
    }
    var weekWeatherData:WeekForecastData? {
        didSet {
            self.updateReadyStatus()
        }
    }
    
    var dataIsReady:Bool = false
    private mutating func updateReadyStatus() {
        if let _ = locationData, let _ = currentWeatherData, let _ = weekWeatherData {
            dataIsReady = true
        } else {
            dataIsReady = false
        }
    }
    
    
}

// MARK: - 对外提供的用于单日天气预报的属性
extension WeatherViewModel: CurrentWeatherRepresenter {
    var cityName:String {
        return locationData?.name ?? ""
    }
    var icon:UIImage? {
        return UIImage.getWeatherIcon(withIconName: currentWeatherData?.icon ?? "")
    }
    var summary:String {
        return currentWeatherData?.summary ?? ""
    }
    var temperature:String {
        return SettingHelper.getTemperatureMode().temperatureText(currentWeatherData?.temperature ?? 0.0)
    }
    var humidity:String {
        return currentWeatherData?.humidity.toHumiditStr() ?? ""
    }
    var time:String {
        let formater = DateFormatter()
        let timeMode = SettingHelper.getDateMode()
        switch timeMode {
        case .text:
            formater.dateFormat = "EEEE, dd MMMM"
        case .digit:
            formater.dateFormat = "E, MM/dd"
        }
        return formater.string(from: currentWeatherData?.time ?? Date.init(timeIntervalSinceNow: 0))

    }
}

// MARK: - 对外提供的用于未来七天预报的属性
extension WeatherViewModel: WeekWeatherRepresenter {
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
        let timeMode = SettingHelper.getDateMode()
        switch timeMode {
        case .text:
            formatter.dateFormat = "MMMM d"
        case .digit:
            formatter.dateFormat = "MM/dd"
        }
        return formatter.string(from: weekWeatherData?.data[index].time ?? Date.init(timeIntervalSinceNow: 0))
    }
    func forecastTemperature(for index:Int) -> String {
        let temMode = SettingHelper.getTemperatureMode()
        let low = temMode.temperatureText(weekWeatherData?.data[index].temperatureLow ?? 0)
        let high = temMode.temperatureText(weekWeatherData?.data[index].temperatureHigh ?? 0)
        
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

protocol CurrentWeatherRepresenter {
    /// 当前城市的名称
    var cityName:String { get }
    /// 当前天气的icon图片
    var icon:UIImage? { get }
    /// 当前天气的文字说明
    var summary:String { get }
    /// 当前温度字符串
    var temperature:String { get }
    /// 当前湿度字符串
    var humidity:String { get }
    /// 今日的时间字符串
    var time:String { get }
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
