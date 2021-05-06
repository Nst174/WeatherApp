//
//  TitleTableViewCell.swift
//  PhoneBook
//
//  Created by 18574230 on 24.02.2021.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    @IBOutlet weak var titleCityLabel: UILabel!
    @IBOutlet weak var titleTempLabel: UILabel!
    @IBOutlet weak var titleDescriptionLabel: UILabel!
    @IBOutlet weak var titleTempDiapLabel: UILabel!
    var titleDTO: TitleDTO? {
        didSet {
            self.update()
        }
    }
    
    func update() {
        titleCityLabel.text = titleDTO?.cityName
        titleTempLabel.text = titleDTO?.currTemp
        titleDescriptionLabel.text = titleDTO?.description
        titleTempDiapLabel.text = titleDTO?.diapTemp
    }

}
