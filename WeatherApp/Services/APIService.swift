//
//  ApiService.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 19.09.23.
//

import Foundation
import Alamofire
import Combine

struct Coordinates {
    let latitude: Double
    let longitude: Double
    
    var value: String {
        return "\(String(latitude)),\(String(longitude))"
    }
}

struct NetworkError: Error {
    let initialError: AFError
    let backendError: BackendError?
}

struct BackendError: Codable, Error {
    var status: String
    var message: String
}

protocol APIServiceProtocol {
    func getForecast(for coordinates: Coordinates) -> AnyPublisher<DataResponse<ForecastModel, NetworkError>, Never>
}

final class APIService {}

extension APIService: APIServiceProtocol {
    func getForecast(for coordinates: Coordinates) -> AnyPublisher<DataResponse<ForecastModel, NetworkError>, Never> {
        let parameters: [String: String] = ["key": Constants.weatherApiKey,
                                            "q": coordinates.value,
                                            "aqi": "no",
                                            "days": "10"]
        return AF.request(URL(string: Constants.forecastRoute)!, parameters: parameters)
            .validate()
            .publishDecodable(type: ForecastModel.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
