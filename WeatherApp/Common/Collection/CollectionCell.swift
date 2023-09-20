//
//  CollectionCell.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 18.09.23.
//

import Foundation

protocol CollectionView {
    func register<Container: ConteinerableView>(in container: Container)
    func instantiate<Item: ReusableView>(in container: Item.Container, for indexPath: IndexPath) -> Item
    func size(for indexPath: IndexPath, toFit container: CGSize) -> CGSize
    func setup<Item: ReusableView>(_ cell: Item)
}

protocol CollectionCell: CollectionView {
    func didSelect()
    func didDeselect()
}
