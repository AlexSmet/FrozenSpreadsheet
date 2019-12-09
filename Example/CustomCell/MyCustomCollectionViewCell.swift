//
//  MyCustomCollectionViewCell.swift
//  skybondsSpreadsheet
//
//  Created by Aleksandr Smetannikov on 08/12/2019.
//  Copyright © 2019 Aleksandr Smetannikov. All rights reserved.
//

import UIKit

class MyCustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!

    func configure(text: String?, isFrozen: Bool = false) {
        label.text = text

        if isFrozen {
            label.backgroundColor = .darkGray
            label.textColor = .white
            label.layer.borderWidth = 0.5
            label.layer.borderColor = UIColor.gray.cgColor
        } else {
            label.backgroundColor = isSelected ? .red : .white
            label.textColor = .black
            label.layer.borderWidth = 0.5
            label.layer.borderColor = UIColor.gray.cgColor
        }
    }
}
