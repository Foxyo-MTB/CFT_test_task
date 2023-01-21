//
//  RecordEditViewController.swift
//  SHIFT_Test_task
//
//  Created by Vladimir Beliakov on 20.01.2023.
//

import UIKit

class RecordEditViewController: UIViewController, Routable {
    
    @IBOutlet var recordTextView: UITextView!
    

    var router: MainRouter?
    var recordText: Record!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(save))
        recordTextView.text = recordText.name
    }
    
    private func setupView() {
    }
    
    @objc private func save() {
        print("Saved")
    }
}
