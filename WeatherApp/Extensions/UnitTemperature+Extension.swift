//
//  UnitTemperature+Extension.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 21.09.23.
//

import Foundation

extension UnitTemperature {
  static var current: UnitTemperature {
    let measureFormatter = MeasurementFormatter()
    let measurement = Measurement(value: 0, unit: UnitTemperature.celsius)
    let output = measureFormatter.string(from: measurement)
    return output == "0°C" ? .celsius : .fahrenheit
  }
}
