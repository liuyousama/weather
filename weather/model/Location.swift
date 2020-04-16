//
//  Location.swift
//  weather
//
//  Created by 六游 on 2020/4/8.
//  Copyright © 2020 六游. All rights reserved.
//

import Foundation
import CoreLocation

struct Location {
    var name:String
    var latitude: Double
    var longitude: Double
    
    var location:CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    init(name:String, latitude:Double, longitude:Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init?(form dict:[String:Any]) {
        guard let name = dict["name"] as? String else {return nil}
        guard let latitude = dict["latitude"] as? Double else {return nil}
        guard let longitude = dict["longitude"] as? Double else {return nil}
        
        self.init(name:name, latitude:latitude, longitude:longitude)
    }
    
    var toDict:[String:Any] {
        return [
            "name":name,
            "latitude":latitude,
            "longitude":longitude
        ]
    }
}


extension Location: Equatable {
    
}
