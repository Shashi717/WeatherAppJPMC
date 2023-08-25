//
//  Main.swift
//  WeatherAppJPMC
//
//  Created by Shashi Liyanage on 8/24/23.
//

struct Main: Codable {
  var temp: Double
  var feelsLike: Double
  var tempMin: Double
  var tempMax: Double
  var humidity: Int

  enum CodingKeys: String, CodingKey {
    case temp
    case feelsLike = "feels_like"
    case tempMin = "temp_min"
    case tempMax = "temp_max"
    case humidity
  }
}
