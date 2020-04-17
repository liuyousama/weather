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
    var locationSearchViewModel = LocationSearchViewModel()
    // MARK: - 生命周期函数
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
        locationSearchViewModel.locationsDidChange = { [weak self] locations in
            self?.tableView.reloadData()
        }
        locationSearchViewModel.searchStatusDidChange = { [weak self] isSearching in
            self?.tableView.reloadData()
        }
    }
}
// MARK: - TableView数据源与代理
extension LocationSearchController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationSearchViewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSearchCell", for: indexPath) as? LocationSearchCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "")
        }
        
        cell.config(with: locationSearchViewModel, at: indexPath.row)
        
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
        let location = locationSearchViewModel.location(for: indexPath.row)
        if let location = location{
            delegate?.controller(self, didSelectLocation: location)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension LocationSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        locationSearchViewModel.searchText = searchText
    }
}


protocol LocationSearchControllerDelegate: AnyObject {
    func controller(_ controller:LocationSearchController, didSelectLocation location:Location)
}
