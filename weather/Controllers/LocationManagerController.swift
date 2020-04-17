//
//  LocationManagerController.swift
//  weather
//
//  Created by 六游 on 2020/4/16.
//  Copyright © 2020 六游. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManagerController: UIViewController {
    // MARK: - outlets and actions
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func clickedDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func clickedAdd(_ sender: Any) {
        print(#function)
    }
    // MARK: - 属性
    var currentLocation:CLLocation?
    var favorites = LocationStore.loadLocations()
    weak var delegate: LocationManagerControllerDelegate?
    
    private var hasFavourites: Bool {
        return favorites.count > 0
    }
    // MARK: - 生命周期函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

// MARK: - tableView的数据源和代理
extension LocationManagerController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : max(1, favorites.count)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Current Location" : "Favourite Locations"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as? LocationCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "")
        }
        var vm: LocationViewModel?
        if indexPath.section == 0 {
            if let currentLocation = currentLocation {
                vm = LocationViewModel(location: currentLocation, locationName: nil)
                cell.locationLable.text = vm?.labelText
            } else {
                cell.locationLable.text = "Current Location Unknown"
            }
        }
        if indexPath.section == 1 {
            if hasFavourites {
                let fav = favorites[indexPath.row]
                vm = LocationViewModel(location: fav.location, locationName: fav.name)
                cell.locationLable.text = vm?.labelText
            } else {
                cell.locationLable.text = "No Favourites Yet..."
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 && hasFavourites {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.favorites.remove(at: indexPath.row)
        LocationStore.saveLocations(self.favorites)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var location:CLLocation?
        if indexPath.section == 0 {
            location = currentLocation
        }
        if indexPath.section == 1 && hasFavourites {
            location = favorites[indexPath.row].location
        }
        
        if let location = location {
            delegate?.controller(self, didSelectLocation: location)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

// MARK: - 搜索地区添加控制器的代理
extension LocationManagerController: LocationSearchControllerDelegate {
    func controller(_ controller: LocationSearchController, didSelectLocation location: Location) {
        favorites.append(location)
        LocationStore.saveLocations(favorites)
        tableView.reloadData()
    }
}

// MARK: - 响应函数
extension LocationManagerController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToLocationSearch", let destVc = segue.destination as? LocationSearchController {
            destVc.modalPresentationStyle = .fullScreen
            destVc.delegate = self
        }
    }
}

protocol LocationManagerControllerDelegate: AnyObject {
    func controller(_ controller: LocationManagerController, didSelectLocation location:CLLocation)
}
