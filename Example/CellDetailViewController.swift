//
//  CellDetailViewController.swift
//  skybondsSpreadsheet
//
//  Created by Aleksandr Smetannikov on 08/12/2019.
//  Copyright © 2019 Aleksandr Smetannikov. All rights reserved.
//

import UIKit

class CellDetailViewController: UIViewController {
    @IBOutlet weak var label: UILabel!

    var text: String?

    func configure(text: String?) {
        self.text = text
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        label.text = text
    }

}
