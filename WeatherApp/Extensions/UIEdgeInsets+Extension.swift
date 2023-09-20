//
//  UIEdgeInsets+Extension.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 20.09.23.
//

import Foundation
import UIKit

public extension UIEdgeInsets {
    func top(_ value: CGFloat) -> UIEdgeInsets {
        .init(top: value, left: left, bottom: bottom, right: right)
    }

    func left(_ value: CGFloat) -> UIEdgeInsets {
        .init(top: top, left: value, bottom: bottom, right: right)
    }

    func bottom(_ value: CGFloat) -> UIEdgeInsets {
        .init(top: top, left: left, bottom: value, right: right)
    }

    func right(_ value: CGFloat) -> UIEdgeInsets {
        .init(top: top, left: left, bottom: bottom, right: value)
    }

    static func top(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets.zero.top(value)
    }

    static func left(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets.zero.left(value)
    }

    static func bottom(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets.zero.bottom(value)
    }

    static func right(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets.zero.right(value)
    }

    static func all(_ value: CGFloat) -> UIEdgeInsets {
        .init(top: value, left: value, bottom: value, right: value)
    }

    func horizontal(_ value: CGFloat) -> UIEdgeInsets {
        .init(top: top, left: value, bottom: bottom, right: value)
    }

    func vertical(_ value: CGFloat) -> UIEdgeInsets {
        .init(top: value, left: left, bottom: value, right: right)
    }

    static func horizontal(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets.zero.horizontal(value)
    }

    static func vertical(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets.zero.vertical(value)
    }
}
