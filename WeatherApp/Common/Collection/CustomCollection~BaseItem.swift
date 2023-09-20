//
//  CustomCollection~BaseItem.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 20.09.23.
//

import Foundation

extension CustomCollection {
    class BaseItem<T: ReusableView & CollectionItem>: CollectionView {
        public func register<Container: ConteinerableView>(in container: Container) { fatalError("Abstract") }
        public func instantiate<Item: ReusableView>(in container: Item.Container, for indexPath: IndexPath) -> Item {
            fatalError("Abstract")
        }

        func register<Container: ConteinerableView>(in container: Container, type: ReuseType, uniqIdentifier: String?) {
            container.register(item: T.self, type: type, uniqIdentifier: uniqIdentifier)
        }

        func instantiate<Item: ReusableView>(in container: Item.Container, for indexPath: IndexPath, type: ReuseType, uniqIdentifier: String?) -> Item {
            container.reuse(item: T.self, for: indexPath, type: type, uniqIdentifier: uniqIdentifier) as? Item ?? fatalError("Can't cast type")
        }

        public func size(for indexPath: IndexPath, toFit container: CGSize) -> CGSize {
            T.size(for: data, toFit: container)
        }

        public func setup<Item>(_ cell: Item) where Item: ReusableView {
            (cell as? T)?.setup(with: data)
        }

        public let data: T.Data
        public init(_ data: T.Data) {
            self.data = data
        }
    }
}
