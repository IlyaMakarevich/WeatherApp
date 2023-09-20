//
//  ReusableView.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 18.09.23.
//

import Foundation

public enum ReuseMethod {
    case `default`
}

public enum ReuseType {
    case cell
    case header
}

public protocol ConteinerableView {
    func register<Item: ReusableView>(item: Item.Type, type: ReuseType, uniqIdentifier: String?)
    func reuse<Item: ReusableView>(item: Item.Type, for indexPath: IndexPath, type: ReuseType, uniqIdentifier: String?) -> Item
}

public protocol ReusableView: AnyObject {
    associatedtype Container: ConteinerableView

    static var reuseIdentifier: String { get }
    static var reuseMethod: ReuseMethod { get }
}

public extension ReusableView where Self: NSObject {
    static var reuseIdentifier: String { description() }
    static var reuseMethod: ReuseMethod { .default }
}
