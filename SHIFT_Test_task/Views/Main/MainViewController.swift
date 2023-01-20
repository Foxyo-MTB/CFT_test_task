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
        baseView.mainTableViewProvidesToVC().dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add record", style: .plain, target: self, action: #selector(addTapped))
        loadRecords()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        baseView.frame = view.bounds
        view.addSubview(baseView)
        loadRecords()
    }
    
    @objc func addTapped() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Добавить новую категорию", message: "", preferredStyle: .alert) //Creating Alert frame
        let action = UIAlertAction(title: "Добавить категорию", style: .default) { (action) in //Creating button "Add category"
            //What will happen when pressed
            let newRecord = Record(context: self.context)                             // Initializating our new item as Categories class item =)
            newRecord.name = textField.text                                               // Getting text of category to Categories()
            self.taskArray.append(newRecord)                                         // Adding new category to categoriesArray.
            self.saveRecord()                                                           // Call function for save categories.
        }
        action.isEnabled = false
        alert.addTextField { (alertTextField) in                                                    // What will be printed in text field.
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: alertTextField, queue: OperationQueue.main, using:
                                                    {_ in
                alertTextField.delegate = self
                // Being in this block means that something fired the UITextFieldTextDidChange notification.
                // Access the textField object from alertController.addTextField(configurationHandler:) above and get the character count of its non whitespace characters
                let textCount = alertTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                let textIsNotEmpty = textCount > 0
                // If the text contains non whitespace characters, enable the OK Button
                action.isEnabled = textIsNotEmpty
                
            })
            alertTextField.placeholder = "Создайте новую категорию"                               // Gray text in text field.
            textField = alertTextField                                                           // Store what printed in textField variably.
            textField.autocapitalizationType = .sentences                                        // Making First letter capital.
        }
        alert.addAction(action)                                                                // Creating button "Add category".
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
        return cell
    }
    
}

extension MainViewController {
    
    func saveRecord() {
        
        do {
            try context.save()                                      // Do-catch block for .save because this method throws an error.
        } catch {
            print("Error saving context, \(error)")
        }
        baseView.mainTableViewProvidesToVC().reloadData()                                      // Shows data IRL on screen
    }
    
    func loadRecords(with request: NSFetchRequest<Record> = Record.fetchRequest()) {            // With - external parameter, request - internal parameter. = Categories.fetchRequest() is a default value here.
        //let request : NSFetchRequest<Categories> = Categories.fetchRequest()    // Specifying type of request, because a lot of different data fetches. <Return an array of items> - meaning. Commented after refactoring code and adding external/internal parameter on string above.
        do {
            taskArray = try context.fetch(request)                  // Do-catch block for .fetch because this method throws an error.
        } catch {
            print("Error fetching data from context, \(error)")
        }
        baseView.mainTableViewProvidesToVC().reloadData()
    }
    
}
