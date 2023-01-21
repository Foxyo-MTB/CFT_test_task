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
    var id: UUID = UUID()
    var isFieldEditing: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightSwipeFunctionality()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(save))
        if recordText != nil {
            recordTextView.text = recordText.name
        } else {
            navigationItem.title = "Напишите заметку"
        }
    }
    
    @objc private func save() {
        if isEditing == false {
            MainViewController.shared.saveRecordAfterCreation(with: recordTextView.text, id: id)
            router?.back()
        } else {
            MainViewController.shared.saveRecordAfterCreation(with: recordTextView.text, id: recordText.id!)
        }
    }
}

extension RecordEditViewController {
    
    private func rightSwipeFunctionality() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            router?.back()
        }
    }
    
}
