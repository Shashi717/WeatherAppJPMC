//
//  ImageAPIClient.swift
//  WeatherAppJPMC
//
//  Created by Shashi Liyanage on 8/24/23.
//

import Foundation
import UIKit

struct ImageAPIClient {

  private let apiService: APIServiceProtocol

  init(apiService: APIServiceProtocol) {
      self.apiService = apiService
  }

  func fetchImage(_ url:URL, completion: @escaping (Result<UIImage, Error>) -> ()) {
    apiService.fetchData(url) { result in
      // call on the main thread because we will do UI refresh when we recieve an image
      DispatchQueue.main.async {
        switch result {
        case .success(let data):
          if let image = UIImage(data: data) {
            completion(.success(image))
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

