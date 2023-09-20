//
//  CollectionViewCell.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 20.09.23.
//

import Foundation
import UIKit

open class CollectionViewCell: UICollectionViewCell {
    public init() {
        super.init(frame: .zero)
        setupView()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    open func setupView() {}
}
