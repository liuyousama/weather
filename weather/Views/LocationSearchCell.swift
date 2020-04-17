//
//  LocationSearchCell.swift
//  weather
//
//  Created by 六游 on 2020/4/17.
//  Copyright © 2020 六游. All rights reserved.
//

import UIKit

class LocationSearchCell: UITableViewCell {
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(with vm:LocationSearchCellRepresentable, at index:Int) {
        locationLabel.text = vm.labelText(for: index)
    }
}
