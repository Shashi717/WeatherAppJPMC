//
//  WeatherAPIClient.swift
//  WeatherAppJPMC
//
//  Created by Shashi Liyanage on 8/24/23.
//

import Foundation

struct WeatherAPIClient {

  private let apiService: APIServiceProtocol

  init(apiService: APIServiceProtocol) {
      self.apiService = apiService
  }

  func fetchWeatherInfo(_ url: URL, completion: @escaping (Result<WeatherInformation, Error>) -> ()) {
    apiService.fetchData(url) { result in
      // call on the main thread because we will do UI refresh when we recieve weather information
      DispatchQueue.main.async {
        switch result {
        case .success(let data):
          if let weatherInfo = try? JSONDecoder().decode(WeatherInformation.self, from: data) {
            completion(.success(weatherInfo))
          } else {
            completion(.failure(NetworkError.decodingError))
          }
        case .failure(let error):
          completion(.failure(error))
        }
      }
    }
  }
}
