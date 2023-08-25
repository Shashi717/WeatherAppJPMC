//
//  WeatherView.swift
//  WeatherAppJPMC
//
//  Created by Shashi Liyanage on 8/24/23.
//

import UIKit

class WeatherView: UIScrollView {

  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var tempLabel: UILabel!
  @IBOutlet weak var highTempLabel: UILabel!
  @IBOutlet weak var lowTempLabel: UILabel!
  @IBOutlet weak var sunriseTimeLabel: UILabel!
  @IBOutlet weak var sunsetTimeLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!

  func configure(weatherViewModel: WeatherViewModel) {
    cityLabel.text = weatherViewModel.locationName
    tempLabel.text = weatherViewModel.currentTemp
    lowTempLabel.text = weatherViewModel.minTemp
    highTempLabel.text = weatherViewModel.maxTemp
    sunriseTimeLabel.text = weatherViewModel.sunriseTime
    sunsetTimeLabel.text = weatherViewModel.sunsetTime
    imageView.image = weatherViewModel.icon
  }
}
