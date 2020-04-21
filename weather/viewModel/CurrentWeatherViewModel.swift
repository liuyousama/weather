//
//  CurrentWeatherViewModel.swift
//  weather
//
//  Created by 六游 on 2020/4/21.
//  Copyright © 2020 六游. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeatherViewModel {
    let weather:CurrentWeather
    
    static let empty = CurrentWeatherViewModel(weather: CurrentWeather.empty)
    
    var isEmpty:Bool {
        return weather == CurrentWeather.empty
    }
}

extension CurrentWeatherViewModel {
    var icon:UIImage? {
        return UIImage.getWeatherIcon(withIconName: weather.icon)
    }
    var summary:String {
        return weather.summary
    }
    var temperature:String {
        return SettingHelper.getTemperatureMode().temperatureText(weather.temperature)
    }
    var humidity:String {
        return weather.humidity.toHumiditStr()
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
        return formater.string(from: weather.time)

    }
}
