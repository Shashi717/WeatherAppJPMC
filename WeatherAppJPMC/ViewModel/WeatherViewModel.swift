//
//  WeatherViewModel.swift
//  WeatherAppJPMC
//
//  Created by Shashi Liyanage on 8/24/23.
//

import Foundation
import UIKit

protocol WeatherViewModelDelegate: AnyObject {
  func didUpdateViewModel(error: Error?)
}

class WeatherViewModel {

  private static let lastSearchedLocationKey = "lastSearchedLocation"
  private let apiService = APIService()
  private let imageCache = NSCache<NSString,UIImage>()
  private var weatherInformation: WeatherInformation?

  weak var delegate: WeatherViewModelDelegate?

  var sunriseTime: String? {
    guard let sunrise = weatherInformation?.sys.sunrise else {
      return nil
    }
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .short
    let sunriseTime = Date(timeIntervalSince1970: TimeInterval(sunrise))
    return "Sunrise: \(dateFormatter.string(from: sunriseTime))"
  }

  var sunsetTime: String? {
    guard let sunset = weatherInformation?.sys.sunset else {
      return nil
    }
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .short
    let sunsetTime = Date(timeIntervalSince1970: TimeInterval(sunset))
    return "Sunset: \(dateFormatter.string(from: sunsetTime))"
  }

  var locationName: String? {
    weatherInformation?.name
  }

  var title: String? {
    weatherInformation?.weather.first?.main
  }

  var minTemp: String? {
    guard let minTemp = weatherInformation?.main.tempMin else {
      return nil
    }
    // TODO: future improvement - change the measuerement according to the metric system used
    return "Low: \(Int(minTemp))°F"
  }

  var maxTemp: String? {
    guard let maxTemp = weatherInformation?.main.tempMax else {
      return nil
    }
    return "High: \(Int(maxTemp))°F"
  }

  var currentTemp: String? {
    guard let temp = weatherInformation?.main.temp else {
      return nil
    }
    return "\(Int(temp))°F"
  }

  var icon: UIImage?

  init(weatherInformation: WeatherInformation? = nil) {
    self.weatherInformation = weatherInformation
  }

  func fetchIcon() {
    guard let iconId = weatherInformation?.weather.first?.icon else {
      return
    }
    let iconIdKey = NSString(string: iconId)
    // if the icon is cahced, then retrieve it from image cache
    if let cachedImage = imageCache.object(forKey: iconIdKey) {
      self.icon = cachedImage
    } else {
      // if not, make an API called to fetch the icon
      guard let iconURL = APIEndpoints.weatherIconEndpoint(iconId) else {
        return
      }
      ImageAPIClient(apiService: apiService).fetchImage(iconURL) { [weak self] result in
        switch result {
        case .success(let image):
          // cache the icon that we fetched
          self?.imageCache.setObject(image, forKey: iconIdKey)
          self?.icon = image
          self?.delegate?.didUpdateViewModel(error: nil)
        case .failure(let error):
          self?.icon = nil
          self?.delegate?.didUpdateViewModel(error: error)
        }
      }
    }
  }

  func fetchWeatherInfo(_ locationName: String) {
    guard let url = APIEndpoints.geocodeAPIEndpoint(locationName) else {
      return
    }
    GeocodeAPIClient(apiService: apiService).fetchGeocode(url) { [weak self] result in
      switch result {
      case .success(let geocode):
        // if we have a geocode then save the last searched location
        if let data = try? JSONEncoder().encode(geocode) {
          UserDefaults.standard.set(data, forKey: WeatherViewModel.lastSearchedLocationKey)
        }
        self?.fetchWeatherInfo(geocode)
      case .failure(_):
        // if fail to fetch from location name then fetch weather info
        // from last searched location
        if let data = UserDefaults.standard.data(forKey: WeatherViewModel.lastSearchedLocationKey),
           let geocode = try? JSONDecoder().decode(Geocode.self, from: data) {
          self?.fetchWeatherInfo(geocode)
        }
      }
    }
  }

  func fetchWeatherInfo(_ geocode: Geocode = Geocode(lat: 40.78, lon: -73.97)) {
    // default location is set to Manhattan (for the first time weather info display)
    guard let url = APIEndpoints.weatherAPIEndpoint(String(geocode.lat), String(geocode.lon)) else {
      return
    }
    WeatherAPIClient(apiService: apiService).fetchWeatherInfo(url) { [weak self] result in
      switch result {
      case .success(let weatherInfo):
        self?.weatherInformation = weatherInfo
        self?.fetchIcon()
        self?.delegate?.didUpdateViewModel(error: nil)
      case .failure(let error):
        self?.weatherInformation = nil
        self?.delegate?.didUpdateViewModel(error: error)
      }
    }
  }
}
