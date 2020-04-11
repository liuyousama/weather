//
//  currentWeatherViewModel.swift
//  weather
//
//  Created by 六游 on 2020/4/9.
//  Copyright © 2020 六游. All rights reserved.
//

import UIKit

struct CurrentWeatherViewModel {
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
    
    var dataIsReady:Bool = false
    
    private mutating func updateReadyStatus() {
        if let _ = locationData, let _ = currentWeatherData {
            dataIsReady = true
        } else {
            dataIsReady = false
        }
    }
    
    // MARK: - 对外提供的属性
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
