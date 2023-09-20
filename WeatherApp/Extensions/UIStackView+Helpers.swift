//
//  UIStackView+Helpers.swift
//  StarWars
//
//  Created by Ilya Makarevich on 5.09.23.
//

import Foundation
import UIKit

public extension UIStackView {
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach { addArrangedSubview($0) }
    }
}
