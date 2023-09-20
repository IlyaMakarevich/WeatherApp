//
//  FutureForecastEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 20.09.23.
//
//

import Foundation
import CoreData


extension FutureForecastEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FutureForecastEntity> {
        return NSFetchRequest<FutureForecastEntity>(entityName: "FutureForecastEntity")
    }

    @NSManaged public var dayForecasts: Set<DayForecastEntity>
    @NSManaged public var forecastEntity: ForecastEntity?

}

// MARK: Generated accessors for dayForecasts
extension FutureForecastEntity {

    @objc(addDayForecastsObject:)
    @NSManaged public func addToDayForecasts(_ value: DayForecastEntity)

    @objc(removeDayForecastsObject:)
    @NSManaged public func removeFromDayForecasts(_ value: DayForecastEntity)

    @objc(addDayForecasts:)
    @NSManaged public func addToDayForecasts(_ values: NSSet)

    @objc(removeDayForecasts:)
    @NSManaged public func removeFromDayForecasts(_ values: NSSet)

}

extension FutureForecastEntity : Identifiable {

}
