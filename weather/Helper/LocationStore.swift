//
//  LocationStore.swift
//  weather
//
//  Created by 六游 on 2020/4/16.
//  Copyright © 2020 六游. All rights reserved.
//

import Foundation

struct LocationStore {
    static private let locationStoreKey = "LocationsKey"
    
    static func saveLocations(_ locations: [Location]) {
        let dicts = locations.map { $0.toDict }
        
        UserDefaults.standard.set(dicts, forKey: self.locationStoreKey)
    }
    
    static func loadLocations() -> [Location] {
        let data = UserDefaults.standard.array(forKey: self.locationStoreKey)
        guard let dicts = data as? [[String:Any]] else {return []}
        return dicts.compactMap {Location.init(form: $0)}
    }
}
