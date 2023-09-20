//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 20.09.23.
//

import Foundation

import CoreData
import UIKit

final class CoreDataManager: NSObject {
    static let shared = CoreDataManager()
    private override init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    func saveForecast(_ model: ForecastDomainModel) {
        guard let forecastEntityDescription = NSEntityDescription.entity(forEntityName: "ForecastEntity", in: context),
              let currentForecastEntityDescription = NSEntityDescription.entity(forEntityName: "CurrentForecastEntity", in: context),
              let futureForecastEntityDescription = NSEntityDescription.entity(forEntityName: "FutureForecastEntity", in: context),
              let dayForecastEntityDescription = NSEntityDescription.entity(forEntityName: "DayForecastEntity", in: context),
              let hourForecastEntityDescription = NSEntityDescription.entity(forEntityName: "HourForecastEntity", in: context)else {
            return
        }
        
        let forecastEntity = ForecastEntity(entity: forecastEntityDescription,
                                            insertInto: context)
        
        forecastEntity.locationName = model.locationName
        forecastEntity.lat = model.lat
        forecastEntity.lon = model.lon
        forecastEntity.tzOffset = Int16(model.tzOffset)
        
        // Current
        let currentEntity = CurrentForecastEntity(entity: currentForecastEntityDescription,
                                                  insertInto: context)
        currentEntity.condition = model.currentForecast.descr
        currentEntity.tempC = model.currentForecast.tempC
        currentEntity.tempF = model.currentForecast.tempF
        forecastEntity.currentForecast = currentEntity
        
        // Future
        let futureEntity = FutureForecastEntity(entity: futureForecastEntityDescription,
                                                insertInto: context)
        
        model.futureForecast.days.forEach { day in
            let dayEntity = DayForecastEntity(entity: dayForecastEntityDescription,
                                              insertInto: context)
            dayEntity.avgTempC = day.avgTempC
            dayEntity.avgTempF = day.avgTempF
            dayEntity.condition = day.condition
            dayEntity.minTempC = day.minTempC
            dayEntity.minTempF = day.minTempF
            dayEntity.maxTempC = day.maxTempC
            dayEntity.maxTempF = day.maxTempF
            dayEntity.visKm = day.visKm
            dayEntity.visMiles = day.visMiles
            dayEntity.windKPH = day.windMPH
            dayEntity.windMPH = day.windMPH
            day.hours.forEach { hour in
                let hourEntity = HourForecastEntity(entity: hourForecastEntityDescription,
                                                    insertInto: context)
                hourEntity.date = hour.date
                hourEntity.condition = hour.condition
                hourEntity.feelC = hour.feelC
                hourEntity.feelF = hour.feelF
                hourEntity.humidity = hour.humidity
                hourEntity.tempC = hour.tempC
                hourEntity.tempF = hour.tempF
                hourEntity.visKm = hour.visKm
                hourEntity.visMiles = hour.visMiles
                hourEntity.windKPH = hour.windKPH
                hourEntity.windMPH = hour.windMPH
                dayEntity.addToHourForecasts(hourEntity)
            }
            futureEntity.addToDayForecasts(dayEntity)
        }
        forecastEntity.futureForecast = futureEntity

        appDelegate.saveContext()
    }
    
    func deleteForecast(locationName: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ForecastEntity")
        request.predicate = NSPredicate(format: "locationName = %@", locationName)
        let result = try? context.fetch(request)
        let resultData = result as! [NSManagedObject]
        resultData.forEach { context.delete($0) }
        appDelegate.saveContext()
    }
    
    
    func fetchForecasts() -> [ForecastEntity]? {
        let fetchRequest: NSFetchRequest<ForecastEntity> = ForecastEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            debugPrint("Error fetching characters")
            return []
        }
    }
}
