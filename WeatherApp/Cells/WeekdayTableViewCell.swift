//
//  WeekdayTableViewCell.swift
//  PhoneBook
//
//  Created by 18574230 on 24.02.2021.
//

import UIKit

class WeekdayTableViewCell: UITableViewCell {
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var weekImageView: UIImageView!
    @IBOutlet weak var weekPopLabel: UILabel!
    @IBOutlet weak var weekMaxTempLabel: UILabel!
    @IBOutlet weak var weekMinTempLabel: UILabel!
    var weekdayDTO: WeekdayDTO?
    {
        didSet {
            self.update()
        }
    }

    func update() {
        weekDayLabel.text = weekdayDTO?.date
        weekImageView.image = UIImage(named: "\(weekdayDTO?.imageName ?? "01d")")
        weekPopLabel.text = weekdayDTO?.pop
        weekMaxTempLabel.text = weekdayDTO?.tempMax
        weekMinTempLabel.text = weekdayDTO?.tempMin
    }

}
