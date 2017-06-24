//
//  ListsManager.swift
//  ListsSiriKit
//
//  Created by Martin Mitrevski on 24.06.17.
//  Copyright © 2017 Martin Mitrevski. All rights reserved.
//

import Foundation

class ListsManager {
    private var savedLists: [String : [String]] = [String : [String]]()
    static let ListsKey = "lists"
    static let GroupId = "group.com.mitrevski.ListsSiriKit"
    static let sharedInstance = ListsManager()
    let sharedDefaults = UserDefaults(suiteName: ListsManager.GroupId)
    
    init() {
        if let saved = sharedDefaults?.value(forKey: ListsManager.ListsKey) {
            savedLists = saved as! [String : [String]]
        }
    }
    
    func lists() -> [String : [String]] {
        return savedLists
    }
    
    func tasksForList(withName name: String) -> [String] {
        if let tasks = savedLists[name] {
            return tasks
        }
        return []
    }
    
    func createList(name: String) {
        let list = [String]()
        updateSavedLists(changedList: list, listName: name)
    }
    
    func deleteList(name: String) {
        updateSavedLists(changedList: nil, listName: name)
    }
    
    func add(tasks: [String], toList listName: String) {
        var list = savedLists[listName] == nil ? [] : savedLists[listName]!
        list.append(contentsOf: tasks)
        updateSavedLists(changedList: list, listName: listName)
    }
    
    func finish(task: String) {
        if let listName = self.findTaskInList(withName: task) {
            var list = savedLists[listName]!
            if let index = list.index(of: task) {
                list.remove(at: index)
                updateSavedLists(changedList: list, listName: listName)
            }
        }
    }
    
    // MARK: private
    
    private func updateSavedLists(changedList: [String]?, listName: String) {
        savedLists[listName] = changedList
        sharedDefaults?.set(savedLists, forKey: ListsManager.ListsKey)
        sharedDefaults?.synchronize()
    }
    
    private func findTaskInList(withName taskName: String) -> String? {
        for (listName, list) in savedLists {
            if list.contains(taskName) {
                return listName
            }
        }
        return nil
    }
}
