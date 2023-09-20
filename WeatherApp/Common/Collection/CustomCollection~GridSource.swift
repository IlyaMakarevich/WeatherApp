//
//  Collection~GridSource.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 18.09.23.
//

import Foundation
import UIKit
import Combine

extension CustomCollection {
    class GridSource: NSObject {
        private let container: UICollectionView

        public var scrollHandler: ((CGPoint) -> Void)?
        public var scrollWillEndDraggingHandler: ((UnsafeMutablePointer<CGPoint>) -> Void)?

        public var displayAnimation: ((UICollectionViewCell, IndexPath) -> Void)?

        private var _sections = [Section]()
        private var cancellable = Set<AnyCancellable>()

        public var sections: [Section] {
            get { _sections }
            set {
                applySections(newValue)
                container.reloadData()
            }
        }

        public func setItems(_ items: [CollectionCell]) {
            sections = [Section(items)]
        }

        public func applySections(_ sections: [Section]) {
            _sections = sections
            registerItems()
        }

        public func applyItems(_ items: [CollectionCell], at section: Int) {
            _sections[section] = .init(header: _sections[section].header, items)
            registerItems()
        }

        public func applyItems(_ items: [CollectionCell]) {
            applySections([Section(items)])
        }

        public func insert(_ item: CollectionCell, at indexPath: IndexPath, animated: Bool, completion: (() -> Void)?) {
            guard let section = _sections[safe: indexPath.section] else { return }
            guard indexPath.item <= section.items.count else { return }

            var items = section.items
            items.insert(item, at: indexPath.item)

            _sections[indexPath.section] = .init(header: section.header, items)
            item.register(in: container)

            if animated {
                container.performBatchUpdates({ [weak container] in
                    container?.insertItems(at: [indexPath])
                }, completion: { _ in completion?() })
            } else {
                container.insertItems(at: [indexPath])
                completion?()
            }
        }

        public func remove(at indexPath: IndexPath, animated: Bool, completion: (() -> Void)?) {
            guard let section = _sections[safe: indexPath.section] else { return }
            guard indexPath.item < section.items.count else { return }

            var items = section.items
            items.remove(at: indexPath.item)
            _sections[indexPath.section] = .init(header: section.header, items)

            if animated {
                container.performBatchUpdates({ [weak container] in
                    container?.deleteItems(at: [indexPath])
                }, completion: { _ in completion?() })
            } else {
                container.deleteItems(at: [indexPath])
                completion?()
            }
        }

        required public init(container: UICollectionView) {
            self.container = container

            super.init()

            self.container.dataSource = self
            self.container.delegate = self

            self.container.publisher(for: \.contentOffset)
                .map { _ in Void() }
                .merge(with: self.container.publisher(for: \.contentSize).map { _ in Void() })
                .sink { [weak self] in
                    guard let self = self else { return }
                    self.scrollHandler?(self.container.contentOffset)
                }
                .store(in: &cancellable)
        }
    }
}

extension Array where Element == CustomCollection.Section {
    subscript(_ path: IndexPath) -> CollectionCell {
        self[path.section].items[path.item]
    }
}

// MARK: - UIScrollViewDelegate
extension CustomCollection.GridSource: UIScrollViewDelegate {
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollWillEndDraggingHandler?(targetContentOffset)
    }
}

// MARK: - UICollectionViewDataSource
extension CustomCollection.GridSource: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].items.count
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        sections[indexPath].setup(cell)
        displayAnimation?(cell, indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        sections[indexPath].instantiate(in: collectionView, for: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = sections[indexPath.section].header else { fatalError(#function) }
            let view: UICollectionReusableView = header.instantiate(in: collectionView, for: indexPath)
            header.setup(view)
            return view
        default: fatalError(#function)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension CustomCollection.GridSource: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sections[indexPath].didSelect()
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        sections[indexPath].didDeselect()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CustomCollection.GridSource: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let flow = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }

        let fitWidth = collectionView.frame.size.width - flow.sectionInset.left - flow.sectionInset.right
        let fitHeight = collectionView.frame.size.height - flow.sectionInset.top - flow.sectionInset.bottom

        return sections[indexPath].size(for: indexPath, toFit: CGSize(width: fitWidth, height: fitHeight))
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        sections[section].header?.size(for: .init(row: 0, section: section), toFit: collectionView.frame.size) ?? .zero
    }
}

private extension CustomCollection.GridSource {
    func registerItems() {
        sections.forEach {
            $0.header?.register(in: container)
            $0.items.forEach { $0.register(in: container) }
        }
    }
}

