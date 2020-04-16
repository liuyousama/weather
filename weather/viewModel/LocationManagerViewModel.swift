//
//  LocationManagerViewModel.swift
//  weather
//
//  Created by 六游 on 2020/4/16.
//  Copyright © 2020 六游. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationViewModel {
    var location:CLLocation?
    var locationName:String?
    
}

extension LocationViewModel: LocationRepresentable {
    
    var labelText: String {
        if let locationName = locationName {
            return locationName
        } else if let location = location {
            let latitude = String(format: "%.3f", location.coordinate.latitude)
            let longitude = String(format: "%.3f", location.coordinate.longitude)
            return "\(latitude),\(longitude)"
        }
        return "Unknown location"
    }
}

protocol LocationRepresentable {
    var labelText:String { get }
}
