//
//  FrozenCollectionViewLayout.swift
//  skybondsSpreadsheet
//
//  Created by Aleksandr Smetannikov on 08/12/2019.
//  Copyright © 2019 Aleksandr Smetannikov. All rights reserved.
//

import UIKit

class FrozenCollectionViewLayout: UICollectionViewFlowLayout {

    private var allAttributes = [[UICollectionViewLayoutAttributes]]()

    var isFreezTopRow: Bool = true
    var isFreezLeftColumn: Bool = true

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func prepare() {
        updateAttributes()
        updateFrozenItemsPositions()
        updateContentSize()
    }

    private func updateAttributes() {
        allAttributes = []

        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0

        for row in 0..<rowsCount {
            var rowAttributes = [UICollectionViewLayoutAttributes]()
            xOffset = 0

            for column in 0..<columnsCount(in: row) {
                let itemSize = size(forRow: row, forColumn: column)
                let indexPath = IndexPath(row: row, column: column)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral

                rowAttributes.append(attributes)
                xOffset += itemSize.width
            }

            allAttributes.append(rowAttributes)
            yOffset += rowAttributes.last?.frame.height ?? 0
        }
    }

    private func updateFrozenItemsPositions() {
        if isFreezTopRow {
            for column in 0..<columnsCount(in: 0) {
                let attributes = allAttributes[0][column]

                var frame = attributes.frame
                frame.origin.y += collectionView!.contentOffset.y
                attributes.frame = frame

                attributes.zIndex = zIndex(forRow: 0, forColumn: column)
            }
        }

        if isFreezLeftColumn {
            for row in 0..<rowsCount {
                let attributes = allAttributes[row][0]

                var frame = attributes.frame
                frame.origin.x += collectionView!.contentOffset.x
                attributes.frame = frame

                attributes.zIndex = zIndex(forRow: row, forColumn: 0)
            }
        }
    }
    
    private func zIndex(forRow row: Int, forColumn column: Int) -> Int {
        let isFrozenTopRow = row == 0 && isFreezTopRow
        let isFrozenLeftColumn = column == 0 && isFreezLeftColumn

        if isFrozenTopRow && isFrozenLeftColumn {
            return 2
        } else if isFrozenTopRow || isFrozenLeftColumn {
            return 1
        } else {
            return 0
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()

        for rowAttributes in allAttributes {
            for item in rowAttributes where rect.intersects(item.frame){
                layoutAttributes.append(item)
            }
        }

        return layoutAttributes
    }

    // MARK: - Размеры

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    private var contentSize = CGSize.zero

    private func updateContentSize() {
        let lastItemFrame = allAttributes.last?.last?.frame ?? .zero
        contentSize = CGSize(width: lastItemFrame.maxX, height: lastItemFrame.maxY)
    }

    var rowsCount: Int {
        return collectionView!.numberOfSections
    }

    func columnsCount(in row: Int) -> Int {
        return collectionView!.numberOfItems(inSection: row)
    }

    func size(forRow: Int, forColumn: Int) -> CGSize {
        let delegate = collectionView!.delegate as! UICollectionViewDelegateFlowLayout
        let size = delegate.collectionView!(collectionView!, layout: self, sizeForItemAt: IndexPath(row: forRow, column: forColumn))
        return size
    }

}

private extension IndexPath {
    init(row: Int, column: Int) {
        self = IndexPath(row: column, section: row)
    }
}
