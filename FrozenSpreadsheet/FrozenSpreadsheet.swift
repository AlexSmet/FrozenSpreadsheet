//
//  FrozenSpreadsheet.swift
//  skybondsSpreadsheet
//
//  Created by Aleksandr Smetannikov on 08/12/2019.
//  Copyright © 2019 Aleksandr Smetannikov. All rights reserved.
//

import UIKit


protocol FrozenSpreadsheetDelegate {
    /// Запрос обычной ячейки
    func cell(forItemAt indexPath: IndexPath, cellRow: Int, cellColumn: Int) -> UICollectionViewCell
    /// Запрос "замороженной" ячейки
    func frozenCell(forItemAt indexPath: IndexPath, cellRow: Int, cellColumn: Int) -> UICollectionViewCell
    /// Событие нажатия на ячейку
    func tapOnCell(_: UICollectionViewCell)
}

class FrozenSpreadsheet: UIView {

    private var collectionView: UICollectionView!

    /// Делегат, должен быть указан обязательно!
    var delegate: FrozenSpreadsheetDelegate!

    /// Число строк в таблице
    var rowsCount: Int = 10
    /// Число столбцов в таблице
    var columnsCount: Int = 10
    /// Размер ячейки
    var cellSize: CGSize = CGSize(width: 100, height: 50) {
        didSet {
            collectionView.reloadData()
        }
    }
    /// Замораживать верхнюю строку
    var isFreezTopRow: Bool {
        get {
            return frozenCollectionViewLayout.isFreezTopRow
        }
        set {
            frozenCollectionViewLayout.isFreezTopRow = newValue
            collectionView.reloadData()
        }
    }
    /// Замораживать левый столбец
    var isFreezLeftColumn: Bool {
        get {
            return frozenCollectionViewLayout.isFreezLeftColumn
        }
        set {
            frozenCollectionViewLayout.isFreezLeftColumn = newValue
            collectionView.reloadData()
        }
    }

    // Свойство добавлено для удобства доступа к свойствам FrozenCollectionViewLayout
    private var frozenCollectionViewLayout: FrozenCollectionViewLayout {
        return collectionView.collectionViewLayout as! FrozenCollectionViewLayout
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        initCollectionView(frame: bounds)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        initCollectionView(frame: CGRect.zero)
    }

    private func initCollectionView(frame: CGRect) {
        collectionView = UICollectionView(frame: frame, collectionViewLayout: FrozenCollectionViewLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.bounces = false

        addSubview(collectionView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
    }

    /// Регистрация ячейки
    func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }

    /// Извлечение ячеек для повторного использования
    func dequeueReusableCell(withReuseIdentifier cellIdentifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) else { return }
        self.delegate?.tapOnCell(selectedCell)
    }

    func isFrozenCell(_ cell: UICollectionViewCell) -> Bool {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return false
        }
        return isFrozenCell(forItemAt: indexPath)
    }

    func isFrozenCell(forItemAt indexPath: IndexPath) -> Bool {
        return (indexPath.row == 0 && isFreezLeftColumn) || (indexPath.section == 0 && isFreezTopRow) 
    }
}


extension FrozenSpreadsheet: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rowsCount
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return columnsCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isFrozenCell(forItemAt: indexPath) {
            return delegate.frozenCell(forItemAt: indexPath, cellRow: indexPath.section, cellColumn: indexPath.row)
        } else {
            return delegate.cell(forItemAt: indexPath, cellRow: indexPath.section, cellColumn: indexPath.row)
        }
    }
}


extension FrozenSpreadsheet: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}
