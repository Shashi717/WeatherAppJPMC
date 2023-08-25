//
//  WeatherInformation.swift
//  WeatherAppJPMC
//
//  Created by Shashi Liyanage on 8/24/23.
//

struct WeatherInformation: Codable {
  var id: Int
  var name: String
  var weather: [Weather]
  var main: Main
  var wind: Wind
  var sys: Sys
}
