//
//  CustomCollection~Item.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 20.09.23.
//

import Foundation
import UIKit

protocol CollectionItem {
    associatedtype Data

    static func size(for data: Data, toFit container: CGSize) -> CGSize
    func setup(with data: Data)
}

extension CustomCollection {
    class Item<T: UICollectionViewCell & CollectionItem>: BaseItem<T>, CollectionCell {
        private let uniqIdentifier: String?

        public func didSelect() {
            didSelectBlock?(data)
        }

        public func didDeselect() {
            didDeselectBlock?(data)
        }

        private let didSelectBlock: ((T.Data) -> Void)?
        private let didDeselectBlock: ((T.Data) -> Void)?

        override public func register<Container: ConteinerableView>(in container: Container) {
            super.register(in: container, type: .cell, uniqIdentifier: uniqIdentifier)
        }

        override public func instantiate<Item: ReusableView>(in container: Item.Container, for indexPath: IndexPath) -> Item {
            super.instantiate(in: container, for: indexPath, type: .cell, uniqIdentifier: uniqIdentifier)
        }

        public init(_ data: T.Data, uniqIdentifier: String? = nil, didDeselect: ((T.Data) -> Void)? = nil, didSelect: ((T.Data) -> Void)? = nil) {
            self.uniqIdentifier = uniqIdentifier
            self.didSelectBlock = didSelect
            self.didDeselectBlock = didDeselect
            super.init(data)
        }
    }
}
