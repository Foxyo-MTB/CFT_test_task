//
//  ViewController.swift
//  SHIFT_Test_task
//
//  Created by Vladimir Beliakov on 20.01.2023.
//

import UIKit
import CoreData

class MainViewController: UIViewController, Routable, UITextFieldDelegate {
    
    
    var router: MainRouter?
    let baseView = MainView()
    var taskArray = [Record]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Добавьте заметку", style: .plain, target: self, action: #selector(addTapped))
        baseView.mainTableViewProvidesToVC().dataSource = self
        baseView.mainTableViewProvidesToVC().delegate = self
        loadRecords()
        firstHardcodedRecord()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        baseView.frame = view.bounds
        view.addSubview(baseView)
        loadRecords()
    }
    
    private func firstHardcodedRecord() {
        if taskArray.isEmpty == true {
            let hardCodedRecord = Record(context: self.context)
            hardCodedRecord.name = "Первая заметка, которая по заданию уже должна быть отображена при первом запуске!"
            saveRecord()
        } else {
            print("Hardcoded record already exists")
        }
    }
    
    @objc func addTapped() {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Добавить новую заметку", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Добавить заметку", style: .default) { (action) in
            let newRecord = Record(context: self.context)
            newRecord.name = textField.text
            self.taskArray.append(newRecord)
            self.saveRecord()
        }
        action.isEnabled = false
        alert.addTextField { (alertTextField) in
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: alertTextField, queue: OperationQueue.main, using:
                                                    {_ in
                alertTextField.delegate = self
                let textCount = alertTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                let textIsNotEmpty = textCount > 0
                // If the text contains non whitespace characters, enable the OK Button
                action.isEnabled = textIsNotEmpty
                
            })
            alertTextField.placeholder = "Создайте новую заметку"
            textField = alertTextField
            textField.autocapitalizationType = .sentences
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
    }
    
}

extension MainViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = baseView.mainTableViewProvidesToVC().dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let record = taskArray[indexPath.row]
        cell.textLabel?.text = record.name
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.presentRecordEditVC()
    }
}
// Extension for save/load/delete
extension MainViewController: UITableViewDelegate {
    
    private func saveRecord() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        baseView.mainTableViewProvidesToVC().reloadData()
    }
    
    private func loadRecords(with request: NSFetchRequest<Record> = Record.fetchRequest()) {            // With - external parameter, request - internal parameter. = Record.fetchRequest() is a default value here.
        do {
            taskArray = try context.fetch(request)                  // Do-catch block for .fetch because this method throws an error.
        } catch {
            print("Error fetching data from context, \(error)")
        }
        baseView.mainTableViewProvidesToVC().reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let contextItem = UIContextualAction(style: .destructive, title: "Удалить") {  (contextualAction, view, boolValue) in
            self.context.delete(self.taskArray[indexPath.row])                                                // Delete from Core Data.
            self.taskArray.remove(at: indexPath.row)                                                          // Delete from Array.
            do {
                try self.context.save()                                                                             //Renew of our Core Data.
                self.baseView.mainTableViewProvidesToVC().reloadData()
            } catch {
                print(error)
            }
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
}
