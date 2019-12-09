//
//  ViewController.swift
//  skybondsSpreadsheet
//
//  Created by Aleksandr Smetannikov on 08/12/2019..
//  Copyright © 2019 Aleksandr Smetannikov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, FrozenSpreadsheetDelegate {

    @IBOutlet weak var frozenSpreadsheet: FrozenSpreadsheet!

    var testData: [[String]] = [
        ["ФИО","Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябь", "Октябрь", "Ноябрь", "Декабрь"],
        ["Александров", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Андреев", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Борисов", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Егоров", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Иванов", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Моисеев", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Петров", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Савельев", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Сидоров", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Яковлев", "", "", "", "", "", "", "", "", "", "", "", ""],
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareTestData()

        let nib = UINib(nibName: "MyCustomCollectionViewCell", bundle: nil)

        // Кастомизация таблицы
        frozenSpreadsheet.delegate = self
        frozenSpreadsheet.register(nib, forCellWithReuseIdentifier: "MyCustomCollectionCell")
        frozenSpreadsheet.columnsCount = testData[0].count
        frozenSpreadsheet.rowsCount = testData.count
        frozenSpreadsheet.cellSize = CGSize(width: 120, height: 40)
        frozenSpreadsheet.isFreezTopRow = true
        frozenSpreadsheet.isFreezLeftColumn = true
    }

    // Заполнение исходных данных
    private func prepareTestData() {
        for (rowIndex, row) in testData.enumerated() {
            guard rowIndex != 0 else { continue }

            for (columnIndex, _) in row.enumerated() {
                guard columnIndex != 0 else { continue }

                let amount: Float = Float(rowIndex)*10000.0 + Float(columnIndex)/100.0
                testData[rowIndex][columnIndex] = String(amount)
            }
        }
    }

    // MARK: - Заполнение ячеек

    // "Замороженные" ячейки
    func frozenCell(forItemAt indexPath: IndexPath, cellRow: Int, cellColumn: Int) -> UICollectionViewCell {
        let cell = frozenSpreadsheet.dequeueReusableCell(withReuseIdentifier: "MyCustomCollectionCell", for: indexPath) as! MyCustomCollectionViewCell

        if cellRow == 0 {
            cell.configure(text: testData[0][cellColumn], isFrozen: true)
            return cell
        }
        if cellColumn == 0 {
            cell.configure(text: testData[cellRow][0], isFrozen: true)
            return cell
        }

        return cell
    }

    // Обычные ячейки
    func cell(forItemAt indexPath: IndexPath, cellRow: Int, cellColumn: Int) -> UICollectionViewCell {
        let cell = frozenSpreadsheet.dequeueReusableCell(withReuseIdentifier: "MyCustomCollectionCell", for: indexPath) as! MyCustomCollectionViewCell

        cell.configure(text: testData[cellRow][cellColumn], isFrozen: false)
        return cell
    }

    // MARK: - Показ детализации ячейки

    func tapOnCell(_ cell: UICollectionViewCell) {
        showCellContent(cell)
    }

    func showCellContent(_ cell: UICollectionViewCell) {
        DispatchQueue.main.async { [weak self] in
            self?.performSegue(withIdentifier: "showCellContent", sender: cell)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedCell = sender as? MyCustomCollectionViewCell else { return }

        if segue.identifier == "showCellContent" {
            if let cellDetailViewController = segue.destination as? CellDetailViewController {
                cellDetailViewController.configure(text: selectedCell.label.text)
            }
        }
    }
}

