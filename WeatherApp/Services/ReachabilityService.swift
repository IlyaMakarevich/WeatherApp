//
//  ReachabilityService.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 20.09.23.
//

import Foundation
import Alamofire

class ReachabilityService {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
