//
//  LocationSearchViewModel.swift
//  weather
//
//  Created by 六游 on 2020/4/17.
//  Copyright © 2020 六游. All rights reserved.
//

import Foundation
import CoreLocation

class LocationSearchViewModel {
    var searchText: String? {
        didSet{
            self.updateResults()
        }
    }
    private var isSearching:Bool {
        didSet {
            DispatchQueue.main.async {
                self.searchStatusDidChange?(self.isSearching)
            }
        }
    }
    private var searchResults:[Location] {
        didSet {
            DispatchQueue.main.async {
                self.locationsDidChange?(self.searchResults)
            }
        }
    }
    
    private lazy var geocoder = CLGeocoder()
    
    var locationsDidChange:(([Location])->Void)?
    var searchStatusDidChange:((Bool)->Void)?
    
    init() {
        isSearching = false
        searchResults = [Location]()
    }
    
    private  func updateResults() {
        isSearching = true
        guard let text = searchText else {
            searchResults = []
            return
        }
        CLGeocoder().geocodeAddressString(text) { [weak self](placeMarks, err) in
            self?.isSearching = false
            if let _ = err {
                self?.searchResults = []
                return
            }
            guard let places = placeMarks else {
                self?.searchResults = []
                return
            }
            
            let locations = places.compactMap({ placeMark -> Location? in
                guard let name = placeMark.name else {return nil}
                guard let location = placeMark.location else {return nil}
                return Location(name: name, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            })
            self?.searchResults = locations
        }
    }
    
}

// MARK: - 提供给外部的属性
extension LocationSearchViewModel: LocationSearchCellRepresentable {
    var totalCount:Int {
        return max(1, searchResults.count)
    }
    
    var sectionTitle:String {
        return isSearching ? "Searching" : "Search Result"
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
