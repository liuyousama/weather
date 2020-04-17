//
//  LocationSearchController.swift
//  weather
//
//  Created by 六游 on 2020/4/17.
//  Copyright © 2020 六游. All rights reserved.
//

import UIKit
import CoreLocation

class LocationSearchController: UIViewController {
    // MARK: - outlets and actions
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func clickCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - 属性
    var locations = [Location]()
    weak var delegate:LocationSearchControllerDelegate?
    // MARK: - 生命周期函数
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
}
// MARK: - TableView数据源与代理
extension LocationSearchController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(1, locations.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSearchCell", for: indexPath) as? LocationSearchCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "")
        }
        
        cell.locationLabel.text = locations.isEmpty ? "No Matches..." : locations[indexPath.row].name
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Search Result"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !locations.isEmpty {
            delegate?.controller(self, didSelectLocation: locations[indexPath.row])
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension LocationSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        geocode(address: searchText)
    }
}

extension LocationSearchController {
    private func geocode(address:String?) {
        guard let address = address else {
            self.locations = []
            tableView.reloadData()
            return
        }
        if address == "" {
            self.locations = []
            tableView.reloadData()
            return
        }
        
        CLGeocoder().geocodeAddressString(address) { (places, err) in
            DispatchQueue.main.async {
                if let _ = err {
                    return
                } else if let places = places {
                    self.locations = places.compactMap({ placemark -> Location? in
                        guard let name = placemark.name else {return nil}
                        guard let location = placemark.location else {return nil}
                        return Location(name: name, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    })
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}


protocol LocationSearchControllerDelegate: AnyObject {
    func controller(_ controller:LocationSearchController, didSelectLocation location:Location)
}
