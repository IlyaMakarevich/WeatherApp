//
//  MainPresenter.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 19.09.23.
//

import Foundation
import Combine

protocol PresenterView: NSObject {
    func displayWeather(_ allData: ForecastDomainModel)
    func displayError()
}

class MainPresenter {
    private let apiService: APIServiceProtocol
    private let locationService: LocationServiceProtocol
    private let persistanceService: PersistanceServiceProtocol
    
    private weak var view: PresenterView?
    private var cancellables = Set<AnyCancellable>()
    
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
                self?.fetchForecastAndSave(for: coordinates)
            }
            .store(in: &cancellables)
    }
    
    private func fetchForecastAndSave(for coordinates: Coordinates) {
        var cancellable: AnyCancellable?
        cancellable = apiService.getForecast(for: coordinates)
            .sink { [weak self] dataResponce in
                cancellable?.cancel()
                switch dataResponce.result {
                case .success(let forecastModel):
                    self?.view?.displayWeather(forecastModel.domainModel)
                    self?.persistanceService.save(forecast: forecastModel.domainModel)
                case .failure(let error):
                    debugPrint("Error with server data: \(error.localizedDescription)")
                    self?.view?.displayError()
                }
            }
    }
}

private extension ForecastModel {
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
            return .init(maxTempC: forecastDay.day.maxtempC,
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

        return .init(locationName: self.location.name,
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
