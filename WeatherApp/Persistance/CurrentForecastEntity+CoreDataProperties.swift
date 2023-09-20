//
//  CurrentForecastEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 20.09.23.
//
//

import Foundation
import CoreData


extension CurrentForecastEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentForecastEntity> {
        return NSFetchRequest<CurrentForecastEntity>(entityName: "CurrentForecastEntity")
    }

    @NSManaged public var tempC: Double
    @NSManaged public var tempF: Double
    @NSManaged public var humidity: Double
    @NSManaged public var windMPH: Double
    @NSManaged public var windKPH: Double
    @NSManaged public var visKm: Double
    @NSManaged public var visMiles: Double
    @NSManaged public var condition: String?
    @NSManaged public var feelC: Double
    @NSManaged public var fellF: Double
    @NSManaged public var conditionCode: Int32
    @NSManaged public var forecastEntity: ForecastEntity?

}

extension CurrentForecastEntity : Identifiable {

}
