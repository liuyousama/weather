//
//  InitialViewController+Table.swift
//  weather
//
//  Created by 六游 on 2020/4/10.
//  Copyright © 2020 六游. All rights reserved.
//

import UIKit

extension InitialViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekWeatherViewModel.dataCount
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return weekWeatherViewModel.sectionCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeekWeatherCell", for: indexPath) as? WeekWeatherTableViewCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "0")
        }
        cell.config(with: weekWeatherViewModel, at: indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
