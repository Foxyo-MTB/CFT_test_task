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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var router: MainRouter?
    var task: Record?
    var selectedRecord: Record? = nil
    var delegate: TransferDataToDetailVCProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightSwipeFunctionality()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonPressed))
                if task != nil {
                    recordTextView.text = task?.name
                } else {
                    navigationItem.title = "Напишите заметку"
                }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        if (task == nil)
        {
            print("add works")
            let newRecord = Record(context: self.context)
            newRecord.id = Int32(delegate.getArray.count)
            newRecord.name = recordTextView.text
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
        //edit record
            print("edit works")
            for element in delegate.getArray {
                if (element.id == task!.id) {
                    element.name = recordTextView.text
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
