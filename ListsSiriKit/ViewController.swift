//
//  ViewController.swift
//  ListsSiriKit
//
//  Created by Martin Mitrevski on 24.06.17.
//  Copyright © 2017 Martin Mitrevski. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let cellIdentifier = "ListsCell"
    @IBOutlet weak var tableView: UITableView!
    var selectedRow: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Lists"
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListsManager.sharedInstance.lists().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        let listName = Array(ListsManager.sharedInstance.lists().keys)[indexPath.row]
        cell?.textLabel?.text = listName
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let listName = Array(ListsManager.sharedInstance.lists().keys)[indexPath.row]
            ListsManager.sharedInstance.deleteList(name: listName)
            self.tableView.reloadData()
        }
    }

    // MARK: UITableViewDataDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRow = indexPath
        self.performSegue(withIdentifier: "showTasks", sender: self)
    }
    
    // MARK: IBAction
    
    @IBAction func addButtonClicked(sender: UIBarButtonItem) {
        let alertController = self.alertForAddingItems()
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTasks" {
            let next = segue.destination as! TasksViewController
            let listName = Array(ListsManager.sharedInstance.lists().keys)[selectedRow!.row]
            next.listName = listName
            selectedRow = nil
        }
    }
    
    // MARK: private
    
    private func alertForAddingItems() -> UIAlertController {
        let alertController = ListsSiriKit.alertForAddingItems(title: "Please provide list name",
                                                  placeholder: "List name")
        return addActions(toAlertController: alertController,
                          saveActionHandler: { [unowned self] action in
            let textField = alertController.textFields![0]
            if let text = textField.text {
                if text != "" {
                    ListsManager.sharedInstance.createList(name: text)
                    self.tableView.reloadData()
                }
            }
            alertController.dismiss(animated: true, completion: nil)
            })
    }
    
}

