//
//  RecordEditViewController.swift
//  SHIFT_Test_task
//
//  Created by Vladimir Beliakov on 20.01.2023.
//

import UIKit
import CoreData

class RecordEditViewController: UIViewController, Routable {
    
    @IBOutlet var recordTextView: UITextView!
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var router: MainRouter?
    var task: Record?
    var delegate: TransferDataToDetailVCProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightSwipeFunctionality()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonPressed))
                if task != nil {
                    recordTextView.attributedText = task?.name
                } else {
                    navigationItem.title = "Напишите заметку"
                }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        recordTextView.becomeFirstResponder()
        recordTextView.allowsEditingTextAttributes = true
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

extension RecordEditViewController {
    
    @objc private func saveButtonPressed() {
        
        let myString = recordTextView.text
        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue,
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 50),
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 50, weight: )]
        let myAttrString = NSAttributedString(string: myString!, attributes: myAttribute)

        // Add new record.
        if (task == nil)
        {
            print("add works")
            let newRecord = Record(context: self.context)
            newRecord.id = Int32(delegate.getArray.count)
            newRecord.name = myAttrString
            delegate.getArray.append(newRecord)
            saveDetailContext()
            do
            {
                try context.save()
                delegate.getArray.append(newRecord)
                router?.back()
            }
            catch
            {
                print("context save error")
            }
        }
        else {
        // Edit record.
            for element in delegate.getArray {
                if (element.id == task!.id) {
                    element.name = myAttrString
                    saveDetailContext()
                }
            }
            router?.back()
        }
    }
}
// Extension for save data to Core data
extension RecordEditViewController {
 
    private func saveDetailContext() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
    }
}
