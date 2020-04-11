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


