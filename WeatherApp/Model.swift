//
//  Model.swift
//  PhoneBook
//
//  Created by 18574230 on 01.02.2021.
//

import Foundation
import UIKit

struct HourlyWeatherForCollection {
    var image: UIImage
    var temp: String
    var time: String

    init(image: UIImage, text: String, time: String) {
        self.image = image
        self.temp = text
        self.time = time
    }
}


struct WeatherDaysAndHourly: Decodable {
    var lat: Float
    var lon: Float
    var timezone: String
    var timezoneOffset: Int?
    var current: Current
    var hourly: [Hourly]
    var daily: [Daily]
    
}

struct Current: Decodable {
    var dt: Int
    var sunrise: Int?
    var sunset: Int?
    var temp: Float
    var feelsLike: Float?
    var pressure: Int
    var humidity: Int
    var dewPoint: Float?
    var uvi: Float
    var clouds: Int
    var visibility: Int
    var windSpeed: Int?
    var windDeg: Int?
    var weather: [Weather]

}

struct Weather: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
    
}

struct Hourly: Decodable {
    var dt: Int
    var temp: Float
    var feelsLike: Float?
    var pressure: Int
    var humidity: Int
    var dewPoint: Float?
    var uvi: Float
    var clouds: Int
    var visibility: Int
    var windSpeed: Float?
    var windDeg: Float?
    var weather: [Weather]
    var pop: Float
    var snow: Snow?
}

struct Snow: Decodable {
    var h1: Float?
}

struct Daily: Decodable {
    var dt: Int
    var sunrise: Int?
    var sunset: Int?
    var temp: Temp
    var feelsLike: FeelsLike?
    var pressure: Int
    var humidity: Int
    var dewPoint: Float?
    var windSpeed: Float?
    var windDeg: Int?
    var weather: [Weather]
    var clouds: Int
    var pop: Float
//    var snow: Snow?
    var uvi: Float
}

struct Temp: Decodable {
    var day: Float
    var min: Float
    var max: Float
    var night: Float
    var eve: Float
    var morn: Float
}

struct FeelsLike: Decodable {
    var day: Float
    var night: Float
    var eve: Float
    var morn: Float

}

struct HourlyWether {
    var time: String
    var imageName: String
    var temperature: String
}

struct TitleDTO {
    var cityName: String
    var currTemp: String
    var description: String
    var diapTemp: String
}

struct HourlyDTO {
    var hourlyWeather: [HourlyWether] = []
}

struct WeekdayDTO {
    var date: String
    var imageName: String
    var pop: String
    var tempMax: String
    var tempMin: String
}

enum RowItem {
    case title(TitleDTO)
    case hourly(HourlyDTO)
    case weekly(WeekdayDTO)
}
