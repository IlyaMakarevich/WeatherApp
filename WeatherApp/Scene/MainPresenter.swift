//
//  MainPresenter.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 19.09.23.
//

import Foundation
import Combine
import CoreLocation

protocol PresenterView: NSObject {
    func displayWeather(_ allData: ForecastDomainModel, fromCache: Bool)
    func displayError(type: ErrorType)
}

class MainPresenter {
    private let apiService: APIServiceProtocol
    private let locationService: LocationServiceProtocol
    private let persistanceService: PersistanceServiceProtocol
    
    private weak var view: PresenterView?
    private var cancellables = Set<AnyCancellable>()
    
    private var isCelsius: Bool {
        return UnitTemperature.current == .celsius
    }
    
    private let distanceConstant = 8000.0 // дистанция в метрах. если кешированная инфа ближе то может использовать эту инфу
        
    init(with view: PresenterView,
         apiService: APIServiceProtocol,
         locationService: LocationServiceProtocol,
         persistanceService: PersistanceServiceProtocol) {
        self.view = view
        self.apiService = apiService
        self.locationService = locationService
        self.persistanceService = persistanceService
        
        subscribeOnLocationChange()
    }
    
    func startTrackingLocation() {
        locationService.requestPermissionAndStartTracking()
    }
    
    func forceUpdateLocation() {
        locationService.forceUpdateLocation()
    }
    
    func subscribeOnLocationChange() {
        locationService.locationTracker
            .sink { [weak self] newLocation in
                let coordinates = Coordinates(latitude: newLocation.coordinate.latitude,
                                        longitude: newLocation.coordinate.longitude)
                
                if !ReachabilityService.isConnectedToInternet {
                    self?.view?.displayError(type: .connection)
                    self?.fetchForecastFromCache(for: coordinates)
                    return
                }
                
                self?.fetchForecastAndSave(for: coordinates)
            }
            .store(in: &cancellables)
    }
    
    func prepareHourlyData(data: [DayForecastDomainModel], tzOffset: Int) -> HourlyForecastViewInfo {
        let nowGmt = Date().toGlobalTime()
        let now = nowGmt.addingTimeInterval(TimeInterval(tzOffset))
        let allHours: [HourForecastDomainModel] = data.reduce(into: [HourForecastDomainModel]()) { partialResult, day in
            partialResult.append(contentsOf: day.hours)
        }

        let allHoursLimited = allHours.sorted(by: { $0.date < $1.date }).filter { $0.date > now }.prefix(24)
        let hours: [HourlyForecastViewInfo.HourItemInfo] = allHoursLimited.map {
            return .init(time: $0.date,
                         code: $0.conditionCode,
                         temp: Int(isCelsius ? $0.tempC : $0.tempF))
        }
        return .init(hours: hours)
    }
    
    func prepareDailyData(data: [DayForecastDomainModel], tzOffset: Int) -> DailyForecastViewInfo {
        let nowGmt = Date().toGlobalTime()
        let now = nowGmt.addingTimeInterval(TimeInterval(tzOffset))
        let allDaysLimited = data.filter {
            $0.date >= now
        }
        let days: [DailyForecastViewInfo.DayItemInfo] = allDaysLimited.map {
            return .init(time: $0.date,
                         code: $0.conditionCode,
                         minTemp: isCelsius ? Int($0.minTempC) : Int($0.minTempF),
                         maxTemp: isCelsius ? Int($0.maxTempC) : Int($0.maxTempF))
        }
        return .init(days: days)
        
    }
    
    private func fetchForecastAndSave(for coordinates: Coordinates) {
        var cancellable: AnyCancellable?
        cancellable = apiService.getForecast(for: coordinates)
            .sink { [weak self] dataResponce in
                cancellable?.cancel()
                switch dataResponce.result {
                case .success(let forecastModel):
                    self?.view?.displayWeather(forecastModel.domainModel, fromCache: false)
                    self?.persistanceService.save(forecast: forecastModel.domainModel)
                case .failure(let error):
                    debugPrint("Error with server data: \(error.localizedDescription)")
                    self?.view?.displayError(type: .server)
                }
            }
    }
    
    private func fetchForecastFromCache(for coordinates: Coordinates) {
        let cachedForecasts = persistanceService.getCachedForecasts()
        let nearestForecasts = cachedForecasts.filter {
            let cachedCoord = CLLocation(latitude: $0.lat, longitude: $0.lon)
            return cachedCoord.distance(from: coordinates.info) < distanceConstant
        }
        if let first = nearestForecasts.first {
            let prepared = removeOldDataFrom(model: first)
            view?.displayWeather(prepared, fromCache: true)
        } else {
            debugPrint("Not found in cache")
            view?.displayError(type: .server)
        }
    }
    
    private func removeOldDataFrom(model: ForecastDomainModel) -> ForecastDomainModel {
        var newModel: ForecastDomainModel?
        let firstActualDay = model.futureForecast.days.first(where: { dayModel in
            dayModel.date > Date()
        })

        if let firstActualDay {
            let allActualDays = model.futureForecast.days.filter {
                $0.date > Date()
            }
            
            let forecastDays: [DayForecastDomainModel] = allActualDays.map {
                return .init(date: $0.date,
                             maxTempC: $0.maxTempC,
                             maxTempF: $0.maxTempF,
                             minTempC: $0.maxTempC,
                             minTempF: $0.maxTempF,
                             avgTempC: $0.avgTempC,
                             avgTempF: $0.avgTempF,
                             windKPH: $0.windKPH,
                             windMPH: $0.windMPH,
                             visKm: $0.visKm,
                             visMiles: $0.visMiles,
                             condition: $0.condition,
                             conditionCode: $0.conditionCode, hours: $0.hours)
            }
            let current = CurrentWeatherDomainModel(tempF: firstActualDay.avgTempF,
                                                   tempC: firstActualDay.avgTempC,
                                                   descr: firstActualDay.condition)
            let futureDomainModel = FutureForecastDomainModel(days: forecastDays)

            let tempModel = ForecastDomainModel(lastUpdated: model.lastUpdated,
                                               locationName: model.locationName,
                                               lat: model.lat,
                                               lon: model.lon,
                                               tzOffset: model.tzOffset, currentForecast: current, futureForecast: futureDomainModel)
            newModel = tempModel
        } else {
            debugPrint("Cant fint actual data in cached feed")
        }
        return newModel ?? model
    }
}

private extension ForecastServerModel {
    var domainModel: ForecastDomainModel {
        let futureDays: [DayForecastDomainModel] = self.forecast.forecastday.map { forecastDay in
            let hours: [HourForecastDomainModel] = forecastDay.hour.map {
                return HourForecastDomainModel(date: $0.timeEpoch.dateFromUnix,
                                               tempC: $0.tempC,
                                               tempF: $0.tempF,
                                               feelC: $0.feelslikeC,
                                               feelF: $0.feelslikeF,
                                               humidity: $0.humidity,
                                               windKPH: $0.windKph,
                                               windMPH: $0.windMph,
                                               visMiles: $0.visMiles,
                                               visKm: $0.visKM,
                                               condition: $0.condition.text,
                                               conditionCode: $0.condition.code)
            }
            return .init(date: forecastDay.dateEpoch.dateFromUnix,
                         maxTempC: forecastDay.day.maxtempC,
                         maxTempF: forecastDay.day.maxtempF,
                         minTempC: forecastDay.day.mintempC,
                         minTempF: forecastDay.day.mintempF,
                         avgTempC: forecastDay.day.avgtempC,
                         avgTempF: forecastDay.day.avgtempF,
                         windKPH: forecastDay.day.maxwindKph,
                         windMPH: forecastDay.day.maxwindMph,
                         visKm: forecastDay.day.avgvisKM,
                         visMiles: Double(forecastDay.day.avgvisMiles),
                         condition: forecastDay.day.condition.text,
                         conditionCode: forecastDay.day.condition.code,
                         hours: hours)
        }
        
        let tz = TimeZone(identifier: self.location.tzID)
        let tzSecondsFromGMT = tz?.secondsFromGMT() ?? 0

        return .init(lastUpdated: self.current.lastUpdatedEpoch.dateFromUnix,
                     locationName: self.location.name,
                     lat: self.location.lat,
                     lon: self.location.lon,
                     tzOffset: tzSecondsFromGMT,
                     currentForecast: .init(tempF: self.current.tempF,
                                            tempC: self.current.tempC,
                                            descr: self.current.condition.text),
                     futureForecast: .init(days: futureDays))
    }
}


private extension Int {
    var dateFromUnix: Date {
        Date(timeIntervalSince1970: TimeInterval(self))
    }
}

private extension Coordinates {
    var info: CLLocation {
        return .init(latitude: self.latitude, longitude: self.longitude)
    }
}
