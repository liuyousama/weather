//
//  SettingViewController.swift
//  weather
//
//  Created by 六游 on 2020/4/11.
//  Copyright © 2020 六游. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate:SettingControllerDelegate?
    
    // MARK: - 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBAction事件
    @IBAction func clickDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SettingViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingData[section].sectionCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingTableViewCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "0")
        }
        
        let section = SettingData[indexPath.section]
        let row = section.sectionCells[indexPath.row]
        cell.cellLabel.text = row.cellTitle
        
        switch section.section {
        case .date:
            let dateMode = SettingHelper.getDateMode()
            cell.accessoryType = row.rawValue == dateMode.rawValue ? .checkmark : .none
        case .temperature:
            let temMode = SettingHelper.getTemperatureMode()
            cell.accessoryType = row.rawValue == temMode.rawValue ? .checkmark : .none
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingData.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SettingData[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = SettingData[indexPath.section]
        let row = section.sectionCells[indexPath.row]
        
        switch section.section {
        case .date:
            let newMode = DateMode(rawValue: row.rawValue) ?? .text
            SettingHelper.setDateMode(newMode)
            delegate?.didChangeTimeMode()
        case .temperature:
            let newMode = TemperatureMode(rawValue: row.rawValue) ?? .celsius
            SettingHelper.setTemperatureMode(newMode)
            delegate?.didChangeTemperatureMode()
        }
        
        tableView.reloadSections([indexPath.section], with: .automatic)
    }
    
}


protocol SettingControllerDelegate: AnyObject {
    func didChangeTimeMode()
    func didChangeTemperatureMode()
}
