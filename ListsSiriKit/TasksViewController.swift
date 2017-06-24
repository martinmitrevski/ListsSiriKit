//
//  TasksViewController.swift
//  ListsSiriKit
//
//  Created by Martin Mitrevski on 24.06.17.
//  Copyright © 2017 Martin Mitrevski. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController, UITableViewDataSource {
    
    private var cellIdentifier = "TasksCell"
    var listName: String?
    var tasks: [String] = [String]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = listName
        tasks = ListsManager.sharedInstance.tasksForList(withName: listName!)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        let taskName = tasks[indexPath.row]
        cell?.textLabel?.text = taskName
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let name = tasks[indexPath.row]
            ListsManager.sharedInstance.finish(task: name)
            self.reloadTasks()
        }
    }
    
    // MARK: IBAction
    
    @IBAction func addButtonClicked(sender: UIBarButtonItem) {
        let alertController = self.alertForAddingItems()
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: private
    
    private func alertForAddingItems() -> UIAlertController {
        let alertController = ListsSiriKit.alertForAddingItems(title: "Please provide task name",
                                                               placeholder: "Task name")
        return addActions(toAlertController: alertController,
                          saveActionHandler: { [unowned self] action in
                            let textField = alertController.textFields![0]
                            if let text = textField.text {
                                if text != "" {
                                    ListsManager.sharedInstance.add(tasks: [text],
                                                                    toList: self.listName!)
                                    self.reloadTasks()
                                }
                            }
                            alertController.dismiss(animated: true, completion: nil)
                         })
    }
    
    private func reloadTasks() {
        tasks = ListsManager.sharedInstance.tasksForList(withName: listName!)
        self.tableView.reloadData()
    }
    
}
