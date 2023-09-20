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
    
    var shortDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        let dayInWeek = dateFormatter.string(from: self)
        return dayInWeek
    }
}
