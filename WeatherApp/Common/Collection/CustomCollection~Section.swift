//
//  Collection~Section.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 18.09.23.
//

import Foundation

extension CustomCollection {
    struct Section {
        public init(header: CollectionView? = nil, _ items: [CollectionCell]) {
            self.header = header
            self.items = items
        }

        public let header: CollectionView?
        public let items: [CollectionCell]
    }
}
