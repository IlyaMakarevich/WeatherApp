//
//  WidgetView.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 21.09.23.
//

import Foundation
import UIKit

enum WidgetType {
    case humidity, feel, windSpeed, visibility
    
    var title: String {
        switch self {
        case .humidity:
            return "Humidity"
        case .feel:
            return "Feel like"
        case .windSpeed:
            return "Wind speed"
        case .visibility:
            return "Visibility"
        }
    }
}

final class WidgetView: BaseView {
    private let titleLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    }
    
    private let infoLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 50, weight: .medium)
    }
    
    override func setupView() {
        super.setupView()
        self.backgroundColor = .black.withAlphaComponent(0.1)
        self.layer.cornerRadius = 10
        self.clipsToBounds = false
        
        addSubviews(titleLabel, infoLabel)
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
        }
        
        infoLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        snp.makeConstraints {
            $0.height.equalTo(120)
        }
    }
    
    func setup(with type: WidgetType, info: String) {
        titleLabel.text = type.title
        infoLabel.text = info
    }
}
