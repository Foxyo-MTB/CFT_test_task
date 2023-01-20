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
    var recordText: Record!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(save))
        recordTextField.text = recordText.name
    }
    
    private func setupView() {
        recordTextField.borderStyle = .none
        //recordTextField.number
    }
    
    @objc private func save() {
        print("Saved")
    }
}
