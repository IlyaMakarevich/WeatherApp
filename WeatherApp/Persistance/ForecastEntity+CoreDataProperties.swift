//
//  ForecastEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 20.09.23.
//
//

import Foundation
import CoreData


extension ForecastEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastEntity> {
        return NSFetchRequest<ForecastEntity>(entityName: "ForecastEntity")
    }

    @NSManaged public var locationName: String?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var tzOffset: Int16
    @NSManaged public var currentForecast: CurrentForecastEntity?
    @NSManaged public var futureForecast: FutureForecastEntity?

}

extension ForecastEntity : Identifiable {

}
