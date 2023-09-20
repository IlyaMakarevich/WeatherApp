//
//  HourlyForecastView.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 19.09.23.
//

import Foundation
import UIKit

final class HourlyForecastView: BaseView {
    private lazy var layout = UICollectionViewFlowLayout().with {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
        $0.sectionInset = .horizontal(14)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).with {
        $0.backgroundColor = .clear
        $0.allowsMultipleSelection = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var source = CustomCollection.GridSource(container: collectionView)

    private typealias Hour = CustomCollection.Item<HourCell>
    
    override func setupView() {
        super.setupView()
        
        snp.makeConstraints {
            $0.height.equalTo(120)
        }
        
        self.backgroundColor = .black.withAlphaComponent(0.1)
        self.layer.cornerRadius = 20
        self.clipsToBounds = false
        
        addSubview(collectionView)
        collectionView.pinToSuperview()
        collectionView.clipsToBounds = true

    }
    
    func setup(with data: [DayForecastDomainModel], tzOffset: Int) {
        let nowGmt = Date().toGlobalTime()
        let now = nowGmt.addingTimeInterval(TimeInterval(tzOffset))
        let allHours: [HourForecastDomainModel] = data.reduce(into: [HourForecastDomainModel]()) { partialResult, day in
            partialResult.append(contentsOf: day.hours)
        }

        let allHoursLimited = allHours.sorted(by: { $0.date < $1.date }).filter { $0.date > now }.prefix(24)
        
        var hourInfos: [CollectionCell] = allHoursLimited.map {
            let hour = Calendar.current.component(.hour, from: $0.date)
            return Hour(.init(time: String(hour),
                              condition: $0.conditionCode,
                              temp: String($0.tempC)))
        }
        source.sections = [.init(header: nil, hourInfos)]
    }
}

