//
//  DailyForecastView.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 19.09.23.
//

import Foundation

final class DailyForecastView: BaseView {
    override func setupView() {
        super.setupView()
        
        snp.makeConstraints {
            $0.height.equalTo(320)
        }
        
        self.backgroundColor = .black.withAlphaComponent(0.1)
        self.layer.cornerRadius = 20
        self.clipsToBounds = false
    }
}
