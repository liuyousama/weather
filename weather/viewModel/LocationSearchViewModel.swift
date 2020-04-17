//
//  LocationSearchViewModel.swift
//  weather
//
//  Created by 六游 on 2020/4/17.
//  Copyright © 2020 六游. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationSearchViewModel {
    var searchText: String? {
        didSet{
            self.updateResults()
        }
    }
    
    private var searchResults = [Location]()
    
    private mutating func updateResults() {
        guard let text = searchText else {
            searchResults = []
            return
        }
        
        let selfPointer = UnsafeMutablePointer(&self)
        CLGeocoder().geocodeAddressString(text) { (placeMarks, err) in
            if let err = err {
                print(err)
                selfPointer.pointee.searchResults = []
                return
            }
            guard let places = placeMarks else {
                selfPointer.pointee.searchResults = []
                return
            }
            
            let locations = places.compactMap({ placeMark -> Location? in
                guard let name = placeMark.name else {return nil}
                guard let location = placeMark.location else {return nil}
                return Location(name: name, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            })
            selfPointer.pointee.searchResults = locations
        }
        
    }
    
}

// MARK: - 提供给外部的属性
extension LocationSearchViewModel: LocationSearchCellRepresentable {
    var totalCount:Int {
        return max(1, searchResults.count)
    }
    
    func location(for index:Int) -> Location? {
        if index >= searchResults.count {return nil}
        return searchResults[index]
    }
    
    func labelText(for index:Int) -> String {
        if searchResults.count == 0 {
            return "No Matches..."
        }
        if index >= searchResults.count {
            return "Unknown Location..."
        }
        return searchResults[index].name
    }
}

protocol LocationSearchCellRepresentable {
    func labelText(for index:Int) -> String
}
