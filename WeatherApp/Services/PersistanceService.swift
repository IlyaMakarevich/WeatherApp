//
//  PersistanceService.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 20.09.23.
//

import Foundation

protocol PersistanceServiceProtocol {
    func save(forecast: ForecastDomainModel)
    func getForecasts()
}

final class PersistanceService: PersistanceServiceProtocol {
    func save(forecast: ForecastDomainModel) {
        CoreDataManager.shared.saveForecast(forecast)
    }
    
    func getForecasts() {
        print(CoreDataManager.shared.fetchForecasts())
    }
    
}
