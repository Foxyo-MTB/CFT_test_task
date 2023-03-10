//
//  ViewController.swift
//  SHIFT_Test_task
//
//  Created by Vladimir Beliakov on 20.01.2023.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITextFieldDelegate, TransferDataToDetailVCProtocol, Routable {
    
    
    private var indexPathSelectedButton: IndexPath?
    private let baseView = MainView()
    var router: MainRouter?
    var taskArray = [Record]()
    var getArray: [Record] {
        get {
            taskArray
        }
        set {
            
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Добавьте заметку", style: .plain, target: self, action: #selector(addTapped))
        baseView.mainTableViewProvidesToVC().dataSource = self
        baseView.mainTableViewProvidesToVC().delegate = self
        firstHardcodedRecordAdds()
        overrideUserInterfaceStyle = .light
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        baseView.frame = view.bounds
        view.addSubview(baseView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadContext()
    }
    
    private func firstHardcodedRecordAdds() {
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            let hardCodedRecord = Record(context: self.context)
            let hadrcodedString = Descriptions.hardcodedText
            let hardCodedAttributes = [ NSAttributedString.Key.font: UIFont(name: "Arial", size: 20)]
            hardCodedRecord.name = NSAttributedString(string: hadrcodedString, attributes: hardCodedAttributes)
            hardCodedRecord.id = 0
            hardCodedRecord.font = Fonts.arialFont
            hardCodedRecord.fontSize = 20
            taskArray.append(hardCodedRecord)
            saveContext()
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    
    @objc func addTapped() {
        router?.presentRecordEditVCForNewRecord(delegate: self)
    }
}

//MARK: - Extension for Data source methods.

extension MainViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let record = taskArray[indexPath.row]
        
        let cell = baseView.mainTableViewProvidesToVC().dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        let attrText = record.name
        cell.mainTableViewLabelProvidesToVC().attributedText = record.name
        if record.imagePhoto == nil {
            cell.mainImageViewProvidesToVC().image = UIImage(named: Pictures.defaultPhoto)
        } else {
            cell.mainImageViewProvidesToVC().image = UIImage(data: record.imagePhoto!)
        }
        cell.action = { [weak self] indexPath in
            self?.indexPathSelectedButton = indexPath
            self?.pickPhotoFromLibrary()
        }
        cell.indexPath = indexPath
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.presentRecordEditVC(with: taskArray[indexPath.row], delegate: self)
    }
}

//MARK: - Extinsion for TableView Delegate methods / actions with

extension MainViewController: UITableViewDelegate {
    
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

//MARK: - Core data save / load.

extension MainViewController {
    
    private func saveContext() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        baseView.mainTableViewProvidesToVC().reloadData()
    }
    
    private func loadContext(with request: NSFetchRequest<Record> = Record.fetchRequest()) {
        
        do {
            taskArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        baseView.mainTableViewProvidesToVC().reloadData()
    }
}

//MARK: - Extension for adding picture to record.

extension MainViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func pickPhotoFromLibrary() {
        print(indexPathSelectedButton?.row)
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.overrideUserInterfaceStyle = .light
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        dismiss(animated:true, completion: nil)
        taskArray[indexPathSelectedButton!.row].imagePhoto = image.pngData()
        saveContext()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
