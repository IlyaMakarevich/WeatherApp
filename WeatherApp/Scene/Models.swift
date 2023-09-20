//
//  Models.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 19.09.23.
//

import Foundation
import UIKit

struct ForecastDomainModel {
    let lastUpdated: Date?
    let locationName: String?
    let lat: Double
    let lon: Double
    let tzOffset: Int
    let currentForecast: CurrentWeatherDomainModel
    let futureForecast: FutureForecastDomainModel
}

struct FutureForecastDomainModel {
    let days: [DayForecastDomainModel]
}


struct CurrentWeatherDomainModel {
    let tempF: Double
    let tempC: Double
    let descr: String?
}

struct DayForecastDomainModel {
    let date: Date
    let maxTempC: Double
    let maxTempF: Double
    let minTempC: Double
    let minTempF: Double
    let avgTempC: Double
    let avgTempF: Double
    let windKPH: Double
    let windMPH: Double
    let visKm: Double
    let visMiles: Double
    let condition: String?
    let conditionCode: Int
    let hours: [HourForecastDomainModel]
}

struct HourForecastDomainModel {
    let date: Date
    let tempC: Double
    let tempF: Double
    let feelC: Double
    let feelF: Double
    let humidity: Double
    let windKPH: Double
    let windMPH: Double
    let visMiles: Double
    let visKm: Double
    let condition: String?
    let conditionCode: Int
}

extension Int {
    var conditionImage: UIImage? {
        switch self {
        case 1000: return UIImage(named: "113")
        case 1003: return UIImage(named: "116")
        case 1006: return UIImage(named: "119")
        case 1009: return UIImage(named: "122")
        case 1030: return UIImage(named: "143")
        case 1063: return UIImage(named: "176")
        case 1066: return UIImage(named: "179")
        case 1069: return UIImage(named: "182")
        case 1072: return UIImage(named: "185")
        case 1087: return UIImage(named: "200")
        case 1114: return UIImage(named: "227")
        case 1117: return UIImage(named: "230")
        case 1135: return UIImage(named: "248")
        case 1147: return UIImage(named: "260")
        case 1150: return UIImage(named: "263")
        case 1153: return UIImage(named: "266")
        case 1168: return UIImage(named: "281")
        case 1171: return UIImage(named: "284")
        case 1180: return UIImage(named: "293")
        case 1183: return UIImage(named: "296")
        case 1186: return UIImage(named: "299")
        case 1189: return UIImage(named: "302")
        case 1192: return UIImage(named: "305")
        case 1195: return UIImage(named: "308")
        case 1198: return UIImage(named: "311")
        case 1201: return UIImage(named: "314")
        case 1204: return UIImage(named: "317")
        case 1207: return UIImage(named: "320")
        case 1210: return UIImage(named: "323")
        case 1213: return UIImage(named: "326")
        case 1216: return UIImage(named: "329")
        case 1219: return UIImage(named: "332")
        case 1222: return UIImage(named: "335")
        case 1225: return UIImage(named: "338")
        case 1237: return UIImage(named: "350")
        case 1240: return UIImage(named: "353")
        case 1246: return UIImage(named: "359")
        case 1252: return UIImage(named: "365")
        case 1258: return UIImage(named: "371")
        case 1264: return UIImage(named: "377")
        case 1273: return UIImage(named: "386")
        case 1276: return UIImage(named: "389")
        case 1279: return UIImage(named: "392")
        case 1282: return UIImage(named: "395")
        default: return nil
        }
    }
}
