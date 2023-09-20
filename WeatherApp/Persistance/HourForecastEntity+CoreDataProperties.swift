//
//  HourForecastEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 20.09.23.
//
//

import Foundation
import CoreData


extension HourForecastEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HourForecastEntity> {
        return NSFetchRequest<HourForecastEntity>(entityName: "HourForecastEntity")
    }

    @NSManaged public var tempC: Double
    @NSManaged public var condition: String?
    @NSManaged public var tempF: Double
    @NSManaged public var feelC: Double
    @NSManaged public var feelF: Double
    @NSManaged public var humidity: Double
    @NSManaged public var windKPH: Double
    @NSManaged public var windMPH: Double
    @NSManaged public var visMiles: Double
    @NSManaged public var visKm: Double
    @NSManaged public var date: Date?
    @NSManaged public var conditionCode: Int32
    @NSManaged public var dayEntity: DayForecastEntity?

}

extension HourForecastEntity : Identifiable {

}
