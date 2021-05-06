//
//  HoursTableViewCell.swift
//  PhoneBook
//
//  Created by 18574230 on 24.02.2021.
//

import UIKit

class HoursTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var hoursDTO: HourlyDTO?
    
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hourlyCollectionView.delegate = self
        hourlyCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hoursDTO?.hourlyWeather.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = hourlyCollectionView.dequeueReusableCell(withReuseIdentifier: "hourlyWeatherCell", for: indexPath) as! WeatherCollectionViewCell
        cell.weather = hoursDTO?.hourlyWeather[indexPath.item]
        return cell
    }
}
