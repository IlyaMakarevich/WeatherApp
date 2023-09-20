//
//  PersistanceService.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 20.09.23.
//

import Foundation

protocol PersistanceServiceProtocol {
    func save(forecast: ForecastDomainModel)
    func getCachedForecasts() -> [ForecastDomainModel]
}

final class PersistanceService: PersistanceServiceProtocol {
    func save(forecast: ForecastDomainModel) {
        CoreDataManager.shared.saveForecast(forecast)
    }
    
    func getCachedForecasts() -> [ForecastDomainModel] {
        guard let cachedEntities = CoreDataManager.shared.fetchForecasts() else {
            return []
        }
        
        var results = [ForecastDomainModel]()
        
        cachedEntities.forEach { cachedEntity in
            guard let current = cachedEntity.currentForecast,
                  let future = cachedEntity.futureForecast else {
                return
            }

            let daysArray = future.dayForecasts.sorted(by: {
                $0.date ?? Date() < $1.date ?? Date()
            })
            
            let daysDomainModels: [DayForecastDomainModel] = daysArray.map { day in
                let hoursArray = day.hourForecasts.sorted(by: {
                    $0.date ?? Date() < $1.date ?? Date()
                })
                let hoursModels: [HourForecastDomainModel] = hoursArray.map {
                    return .init(date: $0.date ?? Date(),
                                 tempC: $0.tempC,
                                 tempF: $0.tempF,
                                 feelC: $0.feelC,
                                 feelF: $0.feelF,
                                 humidity: $0.humidity,
                                 windKPH: $0.windKPH,
                                 windMPH: $0.windMPH,
                                 visMiles: $0.visMiles,
                                 visKm: $0.visKm,
                                 condition: $0.condition,
                                 conditionCode: Int($0.conditionCode))
                }
                return .init(date: day.date ?? Date(),
                             maxTempC: day.maxTempC,
                             maxTempF: day.maxTempF,
                             minTempC: day.minTempC,
                             minTempF: day.minTempF,
                             avgTempC: day.avgTempC,
                             avgTempF: day.avgTempF,
                             windKPH: day.windKPH,
                             windMPH: day.windMPH,
                             visKm: day.visKm,
                             visMiles: day.visMiles,
                             condition: day.condition,
                             conditionCode: Int(day.conditionCode),
                             hours: hoursModels)
            }
            
            let currentDomainModel = CurrentWeatherDomainModel(
                tempF: current.tempF,
                tempC: current.tempC,
                descr: current.condition)
            
            let futureDomainModel = FutureForecastDomainModel(days: daysDomainModels)
            
            let result = ForecastDomainModel(lastUpdated: cachedEntity.lastUpdated,
                                             locationName: cachedEntity.locationName,
                                             lat: cachedEntity.lat,
                                             lon: cachedEntity.lon,
                                             tzOffset: Int(cachedEntity.tzOffset),
                                             currentForecast: currentDomainModel,
                                             futureForecast: futureDomainModel)
            results.append(result)
        }
        return results
    }
    
}
