//
//  HourlyForecastView.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 19.09.23.
//

import Foundation
import UIKit

struct HourlyForecastViewInfo {
    let hours: [HourItemInfo]
    
    struct HourItemInfo {
        let time: Date
        let code: Int
        let temp: Int
    }
}

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
    
    func setup(with data: HourlyForecastViewInfo) {
        let hourInfos: [CollectionCell] = data.hours.enumerated().map { index, item in
            let hour = Calendar.current.component(.hour, from: item.time)
            let time = index == 0 ? "Now": String(hour)
            return Hour(.init(time: time,
                              condition: item.code,
                              temp: String(item.temp)))
        }
        source.sections = [.init(header: nil, hourInfos)]
    }
}

