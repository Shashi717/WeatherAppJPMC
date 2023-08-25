//
//  APIService.swift
//  WeatherAppJPMC
//
//  Created by Shashi Liyanage on 8/24/23.
//

import Foundation

protocol APIServiceProtocol {
    func fetchData(_ url: URL, completion: @escaping(Result<Data, Error>) -> ())
}

struct APIService: APIServiceProtocol {

  func fetchData(_ url: URL, completion: @escaping (Result<Data, Error>) -> ()) {
    URLSession.shared.dataTask(with: url) { data, _, error in
      if let data = data {
        completion(.success(data))
      } else if let error = error {
        completion(.failure(error))
      } else {
        completion(.failure(NetworkError.networkError))
      }
    }.resume()
  }
}

enum NetworkError: Error {
  case networkError
  case decodingError
}
