//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 18.09.23.
//

import Foundation
import UIKit

struct CurrentWeatherViewInfo {
    let locationName: String
    let temp: Double
    let minTemp: Double?
    let maxTemp: Double?
    let condition: String
}

final class CurrentWeatherView: BaseView {
    private let locationLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        $0.numberOfLines = 1
    }
        
    private let currentTempLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 76)
        $0.text = "-"
    }
    
    private let minTempLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.text = "-"
    }
    private let maxTempLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.text = "-"
    }
    private let descriptionLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    
    func setup(with model: CurrentWeatherViewInfo) {
        locationLabel.text = model.locationName
        currentTempLabel.text = model.temp.roundedTempWithoutZero()
        if let maxTemp = model.maxTemp {
            maxTempLabel.text = "Max: " + maxTemp.roundedTempWithoutZero()
        }
        
        if let minTemp = model.minTemp {
            minTempLabel.text = "Min: " + minTemp.roundedTempWithoutZero()
        }
        
        descriptionLabel.text = model.condition
    }
    
    override func setupView() {
        super.setupView()
        
        snp.makeConstraints {
            $0.height.equalTo(200)
        }
        
        let tempsStack = UIStackView().with {
            $0.axis = .horizontal
            $0.spacing = 0
        }
        let separatorLabel = UILabel().with {
            $0.text = ", "
            $0.font = UIFont.systemFont(ofSize: 20)
        }
        tempsStack.addArrangedSubviews([maxTempLabel, separatorLabel, minTempLabel])
        addSubviews(locationLabel, currentTempLabel, descriptionLabel, tempsStack)
        
        
        locationLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        currentTempLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(currentTempLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        tempsStack.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
}



