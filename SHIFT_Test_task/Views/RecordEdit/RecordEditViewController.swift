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
    @IBOutlet var fontChangeOutlet: UIButton!
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var router: MainRouter?
    var task: Record?
    var delegate: TransferDataToDetailVCProtocol!
    var fontSelected: UIFont?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightSwipeFunctionality()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonPressed))
                if task != nil {
                    recordTextView.attributedText = task?.name
                } else {
                    navigationItem.title = "Напишите заметку"
                }
        fontChangeOutlet.setTitle("Изменить шрифт", for: .normal)
        fontChangeOutlet.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("***")
        print(task?.font)
        print("***")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        recordTextView.becomeFirstResponder()
        recordTextView.allowsEditingTextAttributes = true
    }
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
      
//        recordTextView.isEditable = true
//
//        recordTextView.font = UIFont(name: fontSelected!.fontName, size: CGFloat(sender.value))
//
//        recordTextView.isEditable = false
    }
    
    @IBAction func fontChangeButtonPressed(_ sender: UIButton) {
        let config = UIFontPickerViewController.Configuration()
        config.includeFaces = false
        let vc = UIFontPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
    }
}

extension RecordEditViewController: UIFontPickerViewControllerDelegate {
    
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        guard let descriptor = viewController.selectedFontDescriptor else { return }
        recordTextView.font = UIFont(descriptor: descriptor, size: 20)
        fontSelected = UIFont(descriptor: descriptor, size: 20)
        print(fontSelected?.fontName)
        viewController.dismiss(animated: true)
    }

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
    
    func fontPickerViewControllerDidCancel(_ viewController: UIFontPickerViewController) {
        viewController.dismiss(animated: true)

        
    }
    
}

extension RecordEditViewController {
        
    @objc private func saveButtonPressed() {
        
        
        // Add new record.
        if (task == nil)
        {
            let myString = recordTextView.text
            let myAttribute = [ NSAttributedString.Key.font: UIFont(name: fontSelected?.fontName ?? "Arial", size: 20)]
            let myAttrString = NSAttributedString(string: myString!, attributes: myAttribute)
            print("add works")
            let newRecord = Record(context: self.context)
            newRecord.id = Int32(delegate.getArray.count)
            newRecord.name = myAttrString
            newRecord.font = fontSelected?.fontName ?? "Arial"
            delegate.getArray.append(newRecord)
            saveDetailContext()
            router?.back()
        }
        else {
        // Edit record.
            let myString = recordTextView.text
            let myAttribute = [ NSAttributedString.Key.font: UIFont(name: (fontSelected?.fontName ?? task!.font)!, size: 20)]
            let myAttrString = NSAttributedString(string: myString!, attributes: myAttribute)
            for element in delegate.getArray {
                if (element.id == task!.id) {
                    element.name = myAttrString
                    element.font = fontSelected?.fontName ?? task!.font
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
