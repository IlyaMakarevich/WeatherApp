//
//  DayForecastEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 20.09.23.
//
//

import Foundation
import CoreData


extension DayForecastEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayForecastEntity> {
        return NSFetchRequest<DayForecastEntity>(entityName: "DayForecastEntity")
    }

    @NSManaged public var maxTempC: Double
    @NSManaged public var maxTempF: Double
    @NSManaged public var minTempC: Double
    @NSManaged public var minTempF: Double
    @NSManaged public var avgTempC: Double
    @NSManaged public var avgTempF: Double
    @NSManaged public var windKPH: Double
    @NSManaged public var windMPH: Double
    @NSManaged public var visKm: Double
    @NSManaged public var visMiles: Double
    @NSManaged public var condition: String?
    @NSManaged public var conditionCode: Int16
    @NSManaged public var hourForecasts: NSSet?
    @NSManaged public var futureForecasts: FutureForecastEntity?

}

// MARK: Generated accessors for hourForecasts
extension DayForecastEntity {

    @objc(addHourForecastsObject:)
    @NSManaged public func addToHourForecasts(_ value: HourForecastEntity)

    @objc(removeHourForecastsObject:)
    @NSManaged public func removeFromHourForecasts(_ value: HourForecastEntity)

    @objc(addHourForecasts:)
    @NSManaged public func addToHourForecasts(_ values: NSSet)

    @objc(removeHourForecasts:)
    @NSManaged public func removeFromHourForecasts(_ values: NSSet)

}

extension DayForecastEntity : Identifiable {

}
