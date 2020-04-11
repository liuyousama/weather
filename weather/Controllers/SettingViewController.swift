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
    var viewModel:SettingViewModel
    
    // MARK: - 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBAction事件
    @IBAction func clickDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        viewModel = SettingViewModel()
        super.init(coder:coder)
    }
}

extension SettingViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellCount(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingTableViewCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "0")
        }
        
        cell.cellLabel.text = viewModel.cellLable(at: indexPath)
        cell.accessoryType = viewModel.cellAccessoryType(at: indexPath)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionTitle(for: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.changeMode(afterClickAt: indexPath, withDelegate: delegate)
        tableView.reloadData()
    }
    
}


protocol SettingControllerDelegate: AnyObject {
    func didChangeTimeMode()
    func didChangeTemperatureMode()
}
