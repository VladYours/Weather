//
//  WeatherAnswerByGPS.swift
//  weather
//
//  Created by Vlad Rakovich on 16.09.2022.
//

import Foundation

struct WeatherAnswerByGPS: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list:[InHourWeather]
    let city: City
}


struct InHourWeather: Codable {
    let dt: Int
    let main: MainInfo
    let weather: [WeatherItem]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Float
    let sys: Sys
    let dt_txt: String
}


struct MainInfo: Codable {
    let temp: Float
    let feels_like: Float
    let temp_min: Float
    let temp_max: Float
    let pressure: Int
    let sea_level: Int
    let grnd_level: Int
    let humidity: Int
    let temp_kf: Float
}


struct WeatherItem: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}


struct Clouds: Codable {
    let all: Int
}


struct Wind: Codable {
    let speed: Float
    let deg: Int
    let gust: Float
}


struct Sys: Codable {
    let pod: String
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}


struct Coord: Codable {
    let lat: Double
    let lon: Double
}
