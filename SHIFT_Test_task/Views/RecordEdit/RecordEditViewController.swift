//
//  RecordEditViewController.swift
//  SHIFT_Test_task
//
//  Created by Vladimir Beliakov on 20.01.2023.
//

import UIKit

class RecordEditViewController: UIViewController, Routable {
    
    @IBOutlet var recordTextField: UITextField!
    
    var router: MainRouter?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(save))
    }
    
    @objc func save() {
        print("Saved")
    }
}
