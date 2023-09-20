//
//  Double+Extension.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 19.09.23.
//

import Foundation

extension Double {
    func roundedTempWithoutZero() -> String {
        return String(Int(self.rounded())) + "°"
    }
}
