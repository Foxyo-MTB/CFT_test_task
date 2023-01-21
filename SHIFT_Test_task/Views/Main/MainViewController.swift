//
//  ViewController.swift
//  SHIFT_Test_task
//
//  Created by Vladimir Beliakov on 20.01.2023.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITextFieldDelegate, Routable {
    
    
    var router: MainRouter?
    private let baseView = MainView()
    var taskArray = [Record]()
    static let shared = MainViewController()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Добавьте заметку", style: .plain, target: self, action: #selector(addTapped))
        baseView.mainTableViewProvidesToVC().dataSource = self
        baseView.mainTableViewProvidesToVC().delegate = self
        loadRecords()
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            firstHardcodedRecordAdds()
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        baseView.frame = view.bounds
        view.addSubview(baseView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRecords()
    }
    
    private func firstHardcodedRecordAdds() {
        if taskArray.isEmpty == true {
            let hardcodedId: UUID = UUID()
            let hardCodedRecord = Record(context: self.context)
            hardCodedRecord.name = "Первая заметка, которая по заданию уже должна быть отображена при первом запуске! напишу позже тут как работает приложение!"
            hardCodedRecord.id = hardcodedId
            saveRecord()
        } else {
            print("Hardcoded record already exists")
        }
    }
    
    @objc func addTapped() {
        router?.presentRecordEditVCForNewRecord(isFieldEditing: false)
    }
    
    func saveRecordAfterCreation(with record: String, id: UUID) {
        
        if let index = taskArray.firstIndex(where: { $0.id == id}) {
            taskArray[index].name = record
            saveRecord()
            baseView.mainTableViewProvidesToVC().reloadData()
            print("record edited")
        } else {
            if record != "" {
                print("new record added")
                let newRecord = Record(context: self.context)
                newRecord.name = record
                newRecord.id = id
                self.taskArray.append(newRecord)
                self.saveRecord()
                baseView.mainTableViewProvidesToVC().reloadData()
            } else {
                print("You didn't typed text.")
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = baseView.mainTableViewProvidesToVC().dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        let record = taskArray[indexPath.row]
        cell.mainTableViewLabelProvidesToVC().text = record.name
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.presentRecordEditVC(with: taskArray[indexPath.row], isFieldEditing: true)
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
    
    private func loadRecords(with request: NSFetchRequest<Record> = Record.fetchRequest()) {
        
        do {
            taskArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        baseView.mainTableViewProvidesToVC().reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextItem = UIContextualAction(style: .destructive, title: "Удалить") {  (contextualAction, view, boolValue) in
            self.context.delete(self.taskArray[indexPath.row])
            self.taskArray.remove(at: indexPath.row)
            do {
                try self.context.save()
                self.baseView.mainTableViewProvidesToVC().reloadData()
            } catch {
                print(error)
            }
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
}
