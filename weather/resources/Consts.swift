//
//  Consts.swift
//  weather
//
//  Created by 六游 on 2020/4/8.
//  Copyright © 2020 六游. All rights reserved.
//

import Foundation

let DarkskyBaseUrl = URL(string: "https://api.darksky.net/forecast")!
let DarkskySrcretKey = "c014d074736f6e1d36243a24b50f4d90"
let DarkskyUrl = DarkskyBaseUrl.appendingPathComponent(DarkskySrcretKey)
