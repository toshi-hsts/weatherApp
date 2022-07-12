//
//  APIClientDelegate.swift
//  weatherApp
//
//  Created by ToshiPro01 on 2022/07/11.
//

import Foundation

protocol APIClientDelegate {
    func fetchWeather(with json: String) throws -> String
    func fetchWeatherUsingClosure(with json: String,
                                  completion:(_ response: String) -> Void) throws
    func fetchWeatherUsingAsync(with json: String) async throws -> String
}
