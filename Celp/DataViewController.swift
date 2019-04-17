//
//  DataViewController.swift
//  Celp
//
//  Created by Alex Kim on 4/5/19.
//  Copyright © 2019 Alex Kim. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: String = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataLabel?.text = dataObject
    }


}

