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
    @IBOutlet var stepperOutlet: UIStepper!
    @IBOutlet var recordTextViewBottomCOnstraint: NSLayoutConstraint!
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var router: MainRouter?
    var task: Record?
    var delegate: TransferDataToDetailVCProtocol!
    var fontSelected: UIFont?
    var fontSizeSelected: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setObservers()
        setupKeyboardDismissRecognizer()
        rightSwipeFunctionality()
    }
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        
        if (fontSelected?.fontName != nil) {
            recordTextView.font = UIFont(name: fontSelected!.fontName, size: CGFloat(sender.value))
            fontSizeSelected = sender.value
        } else {
            recordTextView.font = UIFont(name: Fonts.arialFont, size: CGFloat(sender.value))
            fontSizeSelected = sender.value
        }
    }
    
    @IBAction func fontChangeButtonPressed(_ sender: UIButton) {
        let config = UIFontPickerViewController.Configuration()
        config.includeFaces = false
        let vc = UIFontPickerViewController(configuration: config)
        vc.overrideUserInterfaceStyle = .light
        vc.delegate = self
        present(vc, animated: true)
    }
    
    private func setObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setView() {
        overrideUserInterfaceStyle = .light
        recordTextView.allowsEditingTextAttributes = true
        stepperOutlet.minimumValue = 10
        stepperOutlet.maximumValue = 30
        stepperOutlet.layer.cornerRadius = 10
        stepperOutlet.overrideUserInterfaceStyle = .dark
        fontChangeOutlet.setTitle("Изменить шрифт", for: .normal)
        fontChangeOutlet.layer.cornerRadius = 10
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(backButtonPressed))
        if task != nil {
            recordTextView.attributedText = task?.name
            stepperOutlet.value = task!.fontSize
            fontSelected = UIFont(name: (task?.font)!, size: task!.fontSize)
        } else {
            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 56/255, green: 56/255, blue: 56/255, alpha: 1)]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
            stepperOutlet.value = 20
            navigationItem.title = "Напишите заметку"
        }
    }
}

//MARK: - Extension for delegate methods.

extension RecordEditViewController: UIFontPickerViewControllerDelegate {
    
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        guard let descriptor = viewController.selectedFontDescriptor else { return }
        recordTextView.font = UIFont(descriptor: descriptor, size: fontSizeSelected ?? 20)
        fontSelected = UIFont(descriptor: descriptor, size: fontSizeSelected ?? 20)
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

//MARK: - Actions in navigation bar.

extension RecordEditViewController {
    
    @objc private func backButtonPressed() {
        router?.back()
    }
    
    @objc private func saveButtonPressed() {
        
        // Add new record.
        if (task == nil)
        {
            let newRecord = Record(context: self.context)
            newRecord.id = Int32(delegate.getArray.count)
            newRecord.name = recordTextView.attributedText
            newRecord.font = fontSelected?.fontName ?? "Arial"
            newRecord.fontSize = fontSizeSelected ?? 20
            delegate.getArray.append(newRecord)
            print(delegate.getArray.count)
            saveDetailContext()
            router?.back()
        }
        else {
            // Edit record.
            let myString = recordTextView.text
            for element in delegate.getArray {
                if (element.id == task!.id) {
                    element.name = recordTextView.attributedText
                    element.font = fontSelected?.fontName ?? task!.font
                    element.fontSize = fontSizeSelected ?? task!.fontSize
                    saveDetailContext()
                }
            }
            router?.back()
        }
    }
}

//MARK: - Core data saving.

extension RecordEditViewController {
    
    private func saveDetailContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
    }
}

//MARK: - extension for editing textView constraint

extension RecordEditViewController {
    
    @objc func keyboardWillShow(notification: Notification) {
        
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight = keyboardSize?.height
        if #available(iOS 11.0, *){
            self.recordTextViewBottomCOnstraint.constant = keyboardHeight! - view.safeAreaInsets.bottom
        }
        else {
            self.recordTextViewBottomCOnstraint.constant = view.safeAreaInsets.bottom
        }
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification){
        self.recordTextViewBottomCOnstraint.constant =  0 // or change according to your logic
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: - Extension for keyboard interaction.

extension RecordEditViewController {
    
    private func setupKeyboardDismissRecognizer(){
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(RecordEditViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
