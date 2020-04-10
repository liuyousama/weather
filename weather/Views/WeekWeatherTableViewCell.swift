//
//  WeekWeatherTableViewCell.swift
//  weather
//
//  Created by 六游 on 2020/4/10.
//  Copyright © 2020 六游. All rights reserved.
//

import UIKit

class WeekWeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var weekTime: UILabel!
    @IBOutlet weak var dayTime: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(with vm:WeekWeatherViewModel, at index:Int) {
        weekTime.text = vm.week(for: index)
        dayTime.text = vm.time(for: index)
        humidity.text = vm.forecastHumidity(for: index)
        temperatureLabel.text = vm.forecastTemperature(for: index)
        icon.image = vm.icon(for: index)
    }

}
