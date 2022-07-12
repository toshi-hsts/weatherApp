//
//  APIClient.swift
//  weatherApp
//
//  Created by ToshiPro01 on 2022/07/11.
//

import Foundation
import YumemiWeather

class APIClient: APIClientDelegate {
    func fetchWeather(with json: String) throws -> String {
        try YumemiWeather.syncFetchWeather(json)
    }
    
    func fetchWeatherUsingClosure(with json: String,
                                  completion: (_ response: String) -> Void) throws {
        let response = try YumemiWeather.syncFetchWeather(json)
        completion(response)
    }
    
    func fetchWeatherUsingAsync(with json: String) async throws -> String {
        try await YumemiWeather.asyncFetchWeather(json)
    }
}
