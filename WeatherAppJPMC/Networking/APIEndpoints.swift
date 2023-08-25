//
//  APIEndpoints.swift
//  WeatherAppJPMC
//
//  Created by Shashi Liyanage on 8/24/23.
//

import Foundation

enum APIEndpoints {
  static func weatherAPIEndpoint(_ lat: String, _ lon: String) -> URL? {
    return URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=cadd8c9c7c0418e8b10cb421e30cf6b3&units=imperial")
  }

  static func geocodeAPIEndpoint(_ locationName: String) -> URL? {
    var components = URLComponents(string: "https://api.openweathermap.org/geo/1.0/direct")
    components?.queryItems = [
      URLQueryItem(name: "q", value: locationName),
      URLQueryItem(name: "limit", value: "1"), // limit results to 1 item
      URLQueryItem(name: "appid", value: "cadd8c9c7c0418e8b10cb421e30cf6b3")
    ]
    return components?.url
  }

  static func weatherIconEndpoint(_ iconId: String) -> URL? {
    return URL(string: "https://openweathermap.org/img/wn/\(iconId)@2x.png")
  }
}
