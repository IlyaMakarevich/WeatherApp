//
//  Date+Extension.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 20.09.23.
//

import Foundation

extension Date {
    func toGlobalTime() -> Date {
         let timezone = TimeZone.current
         let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
         return Date(timeInterval: seconds, since: self)
     }
}
