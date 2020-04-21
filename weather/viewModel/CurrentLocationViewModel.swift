//
//  CurrentLocationViewModel.swift
//  weather
//
//  Created by 六游 on 2020/4/21.
//  Copyright © 2020 六游. All rights reserved.
//

import Foundation

struct CurrentLocationViewModel {
    var location:Location
    
    var city:String {
        return location.name
    }
    
    static let empty = CurrentLocationViewModel(location: Location.empty)
    
    var isEmpty:Bool {
        return self.location == Location.empty
    }
    
}
