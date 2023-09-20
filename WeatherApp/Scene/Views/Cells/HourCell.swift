//
//  HourCell.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 20.09.23.
//

import Foundation
import UIKit

final class HourCell: CollectionViewCell {
    
    private let timeLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .black
    }
    
    private let tempLabel = UILabel().with {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        $0.textColor = .black
    }
    
    private let iconImageView = UIImageView()
    
    override func setupView(){
        super.setupView()
        addSubviews(timeLabel, iconImageView, tempLabel)
        
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.centerX.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(40)
        }
        
        tempLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
        }
    }
}

extension HourCell: CollectionItem {
    struct Data {
        let time: String
        let condition: Int
        let temp: String
    }
    func setup(with data: Data) {
        timeLabel.text = data.time
        tempLabel.text = data.temp + "°"
        iconImageView.image = data.condition.conditionImage
    }
    
    public static func size(for data: Data, toFit container: CGSize) -> CGSize {
        .init(width: 60, height: container.height)
    }
}
