//
//  ViewController.swift
//  WeatherAppJPMC
//
//  Created by Shashi Liyanage on 8/24/23.
//

import CoreLocation
import UIKit

class WeatherViewController: UIViewController {

  @IBOutlet weak var refreshButton: UIBarButtonItem!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var weatherView: WeatherView!

  private let apiService = APIService()
  private let locationManager = CLLocationManager()
  private let imageCache = NSCache<NSString,UIImage>()
  private var weatherViewModel: WeatherViewModel?
  
  private let weatherViewTapGestureRecognizer = UITapGestureRecognizer()

  override func viewDidLoad() {
    super.viewDidLoad()

    weatherViewModel = WeatherViewModel(apiService: apiService, locationManger: locationManager, imageCache: imageCache)
    weatherViewModel?.delegate = self
    weatherViewModel?.fetchWeatherInfo()

    weatherViewTapGestureRecognizer.addTarget(self, action: #selector(didTapWeatherView))
    weatherView.addGestureRecognizer(weatherViewTapGestureRecognizer)

    searchBar.delegate = self
  }

  @IBAction func didTapRefreshButton(_ sender: Any) {
    // in case there is a network failure tapping refresh will refetch the weather info
    searchBar.text = nil
    weatherViewModel?.fetchWeatherInfo()
  }

  @objc func didTapWeatherView() {
    // if we tap out of the search bar (weather view) then we call end editing
    // to dismiss keyboard
    searchBar.endEditing(true)
  }
}

extension WeatherViewController: WeatherViewModelDelegate {
  func didUpdateViewModel(error: Error?) {
    if let error = error {
      // if there's an error, display an alert
      displayAlert(title: "Something went wrong", message: error.localizedDescription)
    }
    // update the view regardless of an error present
    guard let weatherViewModel = weatherViewModel else {
      return
    }
    weatherView.configure(weatherViewModel: weatherViewModel)
  }

  func displayAlert(title: String, message: String) {
    let alertController = self.alertController(title: title, message: message)
    self.present(alertController, animated: true)
  }

  func alertController(title: String, message: String) -> UIAlertController {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default))
    return alertController
  }
}

extension WeatherViewController: UISearchBarDelegate {

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    // dismiss keyboard
    searchBar.endEditing(true)
    guard let query = searchBar.searchTextField.text else { return }
    // fetch weather if there's a search text
    weatherViewModel?.fetchWeatherInfo(query)
  }
}
