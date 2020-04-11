//
//  Setting.swift
//  weather
//
//  Created by 六游 on 2020/4/11.
//  Copyright © 2020 六游. All rights reserved.
//

import Foundation

struct SettingSectionData {
    let section:SettingSection
    let sectionTitle:String
    let sectionCells:[SettingCellData]
}

struct SettingCellData {
    let cellTitle:String
    let rawValue:Int
}

enum SettingSection:Int {
    case date = 0
    case temperature
}

let SettingData = [
    SettingSectionData(section: .date, sectionTitle: "DATE FORMAT", sectionCells: [
        SettingCellData(cellTitle: "Fri, 10 April", rawValue: 0),
        SettingCellData(cellTitle: "F, 4/10", rawValue: 1)
    ]),
    SettingSectionData(section:.temperature, sectionTitle: "TEMPERATURE UNIT", sectionCells: [
        SettingCellData(cellTitle: "20℃", rawValue: 0),
        SettingCellData(cellTitle: "68℉", rawValue: 1)
    ])
]
