//
//  UIView+Extensions.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 18.09.23.
//

import Foundation
import SnapKit
import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }

    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    func autoPinSubview(view: UIView, with edges: UIEdgeInsets) {
        if view.superview != self {
            return
        }
        view.pinTo(self, insets: edges)
    }

    func pinToSuperview(insets: UIEdgeInsets = .zero) {
        snp.makeConstraints { $0.edges.equalToSuperview().inset(insets) }
    }

    func pinTo(_ view: UIView, insets: UIEdgeInsets = .zero) {
        snp.makeConstraints { $0.edges.equalTo(view).inset(insets) }
    }
}
