//
//  GeocodeAPIClient.swift
//  WeatherAppJPMC
//
//  Created by Shashi Liyanage on 8/24/23.
//

import Foundation

struct GeocodeAPIClient {

  private let apiService: APIServiceProtocol

  init(apiService: APIServiceProtocol) {
      self.apiService = apiService
  }

  func fetchGeocode(_ url:URL, completion: @escaping (Result<Geocode, Error>) -> ()) {
    apiService.fetchData(url) { result in
      switch result {
      case .success(let data):
        if let geocodes = try? JSONDecoder().decode([Geocode].self, from: data),
           // we limited results to one item in API call, so pick the first item in geocodes array
           let geocode =  geocodes.first {
          completion(.success(geocode))
        } else {
          completion(.failure(NetworkError.decodingError))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
