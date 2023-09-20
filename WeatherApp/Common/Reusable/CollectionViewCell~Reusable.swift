//
//  File.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 18.09.23.
//

import Foundation
import UIKit

extension UICollectionView: ConteinerableView {
    public func register<Item: ReusableView>(item: Item.Type, type: ReuseType, uniqIdentifier: String?) {
        switch item.reuseMethod {
        case .default:
            switch type {
            case .cell: register(item, forCellWithReuseIdentifier: uniqIdentifier ?? item.reuseIdentifier)
            case .header: register(item,
                                   forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                   withReuseIdentifier: uniqIdentifier ?? item.reuseIdentifier)
            }
        }
    }

    public func reuse<Item: ReusableView>(item: Item.Type, for indexPath: IndexPath, type: ReuseType, uniqIdentifier: String?) -> Item {
        switch type {
        case .cell: return dequeueReusableCell(withReuseIdentifier: uniqIdentifier ?? Item.reuseIdentifier, for: indexPath) as? Item ?? fatalError()
        case .header: return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                              withReuseIdentifier: uniqIdentifier ?? Item.reuseIdentifier,
                                                              for: indexPath) as? Item ?? fatalError()
        }
    }
}

extension UICollectionReusableView: ReusableView {
    public typealias Container = UICollectionView
}
