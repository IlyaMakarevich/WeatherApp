//
//  DailyForecastView.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 19.09.23.
//

import Foundation
import UIKit

struct DailyForecastViewInfo {
    let days: [DayItemInfo]
    
    struct DayItemInfo {
        let time: Date
        let code: Int
        let minTemp: Int
        let maxTemp: Int
    }
}

final class DailyForecastView: BaseView {
    private lazy var layout = UICollectionViewFlowLayout().with {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
        $0.sectionInset = .horizontal(14)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).with {
        $0.backgroundColor = .clear
        $0.allowsMultipleSelection = true
        $0.showsVerticalScrollIndicator = false
    }
    
    private lazy var source = CustomCollection.GridSource(container: collectionView)

    private typealias Day = CustomCollection.Item<DayCell>
    
    override func setupView() {
        super.setupView()
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(DayCell.height)
        }
        
        self.backgroundColor = .black.withAlphaComponent(0.1)
        self.layer.cornerRadius = 20
        self.clipsToBounds = false
    }
    
    func setup(with data: DailyForecastViewInfo) {
        let hourInfos: [CollectionCell] = data.days.enumerated().map {index, item in
            let time = index == 0 ? "Today": item.time.shortDay

            return Day(.init(time: time,
                             condition: item.code,
                             minTemp: String(item.minTemp) + "°",
                             maxTemp: String(item.maxTemp) + "°"))
        }
        source.sections = [.init(header: nil, hourInfos)]
        
        collectionView.snp.updateConstraints {
            $0.height.equalTo(hourInfos.count * Int(DayCell.height))
        }
    }
}
