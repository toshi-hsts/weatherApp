//
//  Response.swift
//  weatherApp
//
//  Created by ToshiPro01 on 2022/07/03.
//

import Foundation

struct Response: Decodable {
    let maxTemperature: Int
    let date: String
    let minTemperature: Int
    let weather: String
    
    private enum CodingKeys: String, CodingKey {
        case maxTemperature = "max_temperature"
        case date
        case minTemperature = "min_temperature"
        case weather = "weather_condition"
    }
}
