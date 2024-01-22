//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Vemula Dinesh on 22/01/24.
//

import Foundation
struct WeatherModel: Codable {
    let main: Main
    let wind: Wind
    let weather: [Weather]
}
struct Main: Codable {
    let temp: Double
    let humidity: Int
    let pressure: Int
}

struct Wind: Codable {
    let speed: Double
}

struct Weather: Codable {
    let main: String
    let description: String
}
