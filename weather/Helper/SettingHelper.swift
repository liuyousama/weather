//
//  Setting.swift
//  weather
//
//  Created by 六游 on 2020/4/11.
//  Copyright © 2020 六游. All rights reserved.
//

import Foundation

enum TemperatureMode:Int {
    case celsius = 0
    case fahrenheit
    
    func temperatureText(_ tem:Double) -> String {
        switch self {
        case .celsius:
            return tem.toCelsiusStr()
        case .fahrenheit:
            return tem.toFahrenheitStr()
        }
    }
}

enum DateMode:Int {
    case text = 0
    case digit
    
    func formatStr() -> String {
        switch self {
        case .text:
            return "EEEE, dd MMMM"
        case .digit:
            return "E, MM/dd"
        }
    }
}

struct SettingHelper {
    private static let TemperatureModeKey = "TemperatureModeSettingKey"
    private static let DateModeKey = "DateModeSettingKey"
    
    // MARK: - 设置项存取方法
    static func setTemperatureMode(_ mode:TemperatureMode) {
        UserDefaults.standard.set(mode.rawValue, forKey: TemperatureModeKey)
    }
    static func setDateMode(_ mode:DateMode) {
        UserDefaults.standard.set(mode.rawValue, forKey:DateModeKey)
    }
    
    static func getTemperatureMode() -> TemperatureMode {
        let raw = UserDefaults.standard.integer(forKey: TemperatureModeKey)
        let mode = TemperatureMode(rawValue: raw)
        return mode ?? .celsius
    }
    static func getDateMode() -> DateMode {
        let raw = UserDefaults.standard.integer(forKey: DateModeKey)
        let mode = DateMode(rawValue: raw)
        return mode ?? .text
    }
}
