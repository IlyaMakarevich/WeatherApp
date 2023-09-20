//
//  DayCell.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 20.09.23.
//


import Foundation
import UIKit

final class DayCell: CollectionViewCell {
    
    static let height = 80.0
    
    private let dayLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .black
    }
    
    private let iconImageView = UIImageView()

    private let minTempLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        $0.textColor = .black
    }
    
    private let maxTempLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        $0.textColor = .black
    }
    
    
    override func setupView(){
        super.setupView()
        addSubviews(dayLabel, iconImageView, minTempLabel, maxTempLabel)
        
        dayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(100)
        }
        
        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(80)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(54)
        }
        
        maxTempLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
        
        minTempLabel.snp.makeConstraints {
            $0.trailing.equalTo(maxTempLabel.snp.leading).offset(-40)
            $0.centerY.equalToSuperview()
        }
    }
}

extension DayCell: CollectionItem {
    struct Data {
        let time: String
        let condition: Int
        let minTemp: String
        let maxTemp: String
    }
    func setup(with data: Data) {
        dayLabel.text = data.time
        minTempLabel.text = "min: \(data.minTemp)"
        maxTempLabel.text = "max: \(data.maxTemp)"
        iconImageView.image = data.condition.conditionImage
    }
    
    public static func size(for data: Data, toFit container: CGSize) -> CGSize {
        .init(width: container.width, height: Self.height)
    }
}
