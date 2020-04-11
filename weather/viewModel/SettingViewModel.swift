//
//  SettingViewModel.swift
//  weather
//
//  Created by 六游 on 2020/4/11.
//  Copyright © 2020 六游. All rights reserved.
//

import UIKit

struct SettingViewModel {
    var dateMode:DateMode
    var temMode:TemperatureMode
    
    private static var settingData = [
        SettingSectionData(section: .date, sectionTitle: "DATE FORMAT", sectionCells: [
            SettingCellData(cellTitle: "Fri, 10 April", rawValue: 0),
            SettingCellData(cellTitle: "F, 4/10", rawValue: 1)
        ]),
        SettingSectionData(section:.temperature, sectionTitle: "TEMPERATURE UNIT", sectionCells: [
            SettingCellData(cellTitle: "20℃", rawValue: 0),
            SettingCellData(cellTitle: "68℉", rawValue: 1)
        ])
    ]
    
    init() {
        dateMode = SettingHelper.getDateMode()
        temMode = SettingHelper.getTemperatureMode()
    }
    
    var sectionCount:Int {
        SettingViewModel.settingData.count
    }
    func sectionTitle(for section:Int) -> String {
        return SettingViewModel.settingData[section].sectionTitle
    }
    
    func cellCount(for section:Int) -> Int {
        return SettingViewModel.settingData[section].sectionCells.count
    }
    func cellLable(at indexPath:IndexPath) -> String {
        return SettingViewModel.settingData[indexPath.section].sectionCells[indexPath.row].cellTitle
    }
    func cellAccessoryType(at indexPath:IndexPath) -> UITableViewCell.AccessoryType {
        let section = SettingViewModel.settingData[indexPath.section]
        let row = section.sectionCells[indexPath.row]
        switch section.section {
        case .date:
            return row.rawValue == dateMode.rawValue ? .checkmark : .none
        case .temperature:
            return row.rawValue == temMode.rawValue ? .checkmark : .none
        }
    }
    mutating func changeMode(afterClickAt indexPath:IndexPath, withDelegate delegate:SettingControllerDelegate?) {
        let section = SettingViewModel.settingData[indexPath.section]
        let row = section.sectionCells[indexPath.row]
        
        switch section.section {
        case .date:
            let newMode = DateMode(rawValue: row.rawValue) ?? .text
            if newMode == dateMode { return }
            SettingHelper.setDateMode(newMode)
            dateMode = newMode
            delegate?.didChangeTimeMode()
        case .temperature:
            let newMode = TemperatureMode(rawValue: row.rawValue) ?? .celsius
            if newMode == temMode {return}
            SettingHelper.setTemperatureMode(newMode)
            temMode = newMode
            delegate?.didChangeTemperatureMode()
        }
    }
}
