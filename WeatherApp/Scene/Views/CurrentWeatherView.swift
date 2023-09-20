//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 18.09.23.
//

import Foundation
import UIKit

final class CurrentWeatherView: BaseView {
    
    private let locationLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        $0.numberOfLines = 1
    }
        
    private let currentTempLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 76)
    }
    
    private let minTempLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    private let maxTempLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    private let descriptionLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    
    func setup(with model: ForecastDomainModel) {
        locationLabel.text = model.locationName
        currentTempLabel.text = String(model.currentForecast.tempC.roundedWithoutZero()) + "°"
        maxTempLabel.text = "to do "//"Max: " + (model.roundedWithoutZero() ?? "-")
        minTempLabel.text = "to do" //+ (model.minTempC?.roundedWithoutZero() ?? "-")
        descriptionLabel.text = model.currentForecast.descr
    }
    
    override func setupView() {
        super.setupView()
        clipsToBounds = false
        
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



