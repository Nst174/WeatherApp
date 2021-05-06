//
//  WeatherViewController.swift
//  PhoneBook
//
//  Created by 18574230 on 01.02.2021.
//

import CoreLocation
import Foundation
import UIKit

/* примеры URL. Поместил сюда для удобного копирования
//https://api.openweathermap.org/data/2.5/onecall?lat=55.7522&lon=37.6156&exclude=minutely,alerts&units=metric&appid=f3a3420cba3f2e5ff5bf2bb5f5f9f1b8
//https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)*/

class WeatherViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var weatherTableView: UITableView!
    var rowItems: [[RowItem]] = []
    var dataFromJson: WeatherDaysAndHourly?
    var city: String = "Moscow"
    let apiKey = "f3a3420cba3f2e5ff5bf2bb5f5f9f1b8"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDataFromUrl()
        
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        weatherTableView.reloadData()
    }
    
}
    
extension WeatherViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return rowItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = rowItems[indexPath.section][indexPath.row]
        switch item {
        case .title(let titleDTO):
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCellId", for: indexPath) as! TitleTableViewCell
            cell.titleDTO = titleDTO
            return cell
        case .hourly(let hourDTO):
            let cell = tableView.dequeueReusableCell(withIdentifier: "hourCellId", for: indexPath) as! HoursTableViewCell
            cell.hoursDTO = hourDTO
            return cell
        case .weekly(let weekDTO):
            let cell = tableView.dequeueReusableCell(withIdentifier: "weekCellId", for: indexPath) as! WeekdayTableViewCell
            cell.weekdayDTO = weekDTO
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch rowItems[indexPath.section][indexPath.row] {
        case .title:
            return 200
        case .hourly:
            return 120
        case .weekly:
            return 40
        }
    }
    
    func updateWeather(weatherUpdate: WeatherDaysAndHourly) {
        dataFromJson = weatherUpdate
        if dataFromJson != nil {
            let title = TitleDTO(
                cityName: city,
                currTemp: String(Int(dataFromJson?.current.temp ?? 0)),
                description: (dataFromJson?.current.weather[0].description)!,
                diapTemp: "Max. \(String(Int(dataFromJson?.daily[0].temp.max ?? 0)))º, Min. \(String(Int(dataFromJson?.daily[0].temp.min ?? 0)))º")
            rowItems.append([.title(title)])
            weatherTableView.reloadData()
            
            var hourly: [HourlyWether] = []
            for i in 0...23 {
                hourly.append((HourlyWether(
                                time: "\(unixTimeConvertion(unixTime: Double(dataFromJson?.hourly[i].dt ?? 0)))",
                                imageName: "\(dataFromJson?.hourly[i].weather[0].icon ?? "01d")",
                                temperature: "\(Int(dataFromJson?.hourly[i].temp ?? 0))º")))
            }
            hourly[0].time = "Now"
            rowItems.append([.hourly(HourlyDTO(hourlyWeather: hourly))])
            weatherTableView.reloadData()
            
            var i = 1
            let date = Date()
            let calendar = Calendar.current
            let wd = calendar.component(.weekday, from: date)
            var weekly: [RowItem] = []
            while i < (dataFromJson?.daily.count)! {
                let weekday = DateFormatter().weekdaySymbols[(wd - 1 + i) % 7]
                weekly.append(.weekly(WeekdayDTO(
                                        date: "\(weekday)", imageName: "\(dataFromJson?.daily[i].weather[0].icon ?? "01d")",
                                        pop: "\(Int((dataFromJson?.daily[i].pop ?? 0)*100))%",
                                        tempMax: "\(Int(dataFromJson?.daily[i].temp.max ?? 0))º",
                                        tempMin: "\(Int(dataFromJson?.daily[i].temp.min ?? 0))º")))
                i += 1
            }
            rowItems.append(weekly)
            weatherTableView.reloadData()
        }

    }
    
    func getDataFromUrl() {
        guard let urlDaysAndHourly = URL (string: "https://api.openweathermap.org/data/2.5/onecall?lat=55.7522&lon=37.6156&exclude=minutely,alerts&units=metric&appid=\(apiKey)") else { return }
        let session = URLSession.shared
        session.dataTask(with: urlDaysAndHourly) { (data, response, error) in
            if let response = response {
                print(response)
            }
            guard let data = data else { return }
            do {
                let weatherDaysAndHourly = try JSONDecoder().decode(WeatherDaysAndHourly.self, from: data)
                DispatchQueue.main.async {
                    self.updateWeather(weatherUpdate: weatherDaysAndHourly)
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func getWeekDay(unixTime: Int) -> Date {
        let timeResult = Double(unixTime)
        let date = Date(timeIntervalSince1970: timeResult)
        return date
    }
    
    func unixTimeConvertion(unixTime: Double) -> String {
        
        let time = NSDate(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.system.identifier) as Locale?
        dateFormatter.dateFormat = "hh:mm a"
        let dateAsString = dateFormatter.string(from: time as Date)
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "HH:mm"
        let date24 = dateFormatter.string(from: date!).components(separatedBy: ":")
        return date24[0]
    }

}

class WeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabelCV: UILabel!
    @IBOutlet weak var imageCV: UIImageView!
    @IBOutlet weak var tempLabelCV: UILabel!
    
    var weather: HourlyWether? {
        didSet {
            self.update()
        }

    }
    func update() {
        if let weather = weather{
            imageCV.image = UIImage(named: weather.imageName)
            tempLabelCV.text = weather.temperature
            timeLabelCV.text = weather.time
        }
        else {
            imageCV.image = UIImage(named: "info")
            tempLabelCV.text = "?"
            timeLabelCV.text = "?"
        }
    }
}
