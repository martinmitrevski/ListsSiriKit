//
//  IntentHandler.swift
//  Siri
//
//  Created by Martin Mitrevski on 24.06.17.
//  Copyright © 2017 Martin Mitrevski. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
    func createTasks(fromTitles taskTitles: [String]) -> [INTask] {
        var tasks: [INTask] = []
        tasks = taskTitles.map { taskTitle -> INTask in
            let task = INTask(title: taskTitle,
                              status: .notCompleted,
                              taskType: .completable,
                              spatialEventTrigger: nil,
                              temporalEventTrigger: nil,
                              createdDateComponents: nil,
                              modifiedDateComponents: nil,
                              identifier: nil)
            return task
        }
        return tasks
    }
      
}

extension IntentHandler : INCreateTaskListIntentHandling {
    
    public func handle(createTaskList intent: INCreateTaskListIntent,
                       completion: @escaping (INCreateTaskListIntentResponse) -> Swift.Void) {
        
        guard let title = intent.title else {
            completion(INCreateTaskListIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        ListsManager.sharedInstance.createList(name: title)
        
        var tasks: [INTask] = []
        if let taskTitles = intent.taskTitles {
            tasks = createTasks(fromTitles: taskTitles)
            ListsManager.sharedInstance.add(tasks: taskTitles, toList: title)
        }
        
        let response = INCreateTaskListIntentResponse(code: .success, userActivity: nil)
        response.createdTaskList = INTaskList(title: title,
                                              tasks: tasks,
                                              groupName: nil,
                                              createdDateComponents: nil,
                                              modifiedDateComponents: nil,
                                              identifier: nil)
        completion(response)
    }
    
}

extension IntentHandler : INAddTasksIntentHandling {
    
    public func handle(addTasks intent: INAddTasksIntent,
                       completion: @escaping (INAddTasksIntentResponse) -> Swift.Void) {
        
        let taskList = intent.targetTaskList
        
        guard let title = taskList?.title else {
            completion(INAddTasksIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        var tasks: [INTask] = []
        if let taskTitles = intent.taskTitles {
            tasks = createTasks(fromTitles: taskTitles)
            ListsManager.sharedInstance.add(tasks: taskTitles, toList: title)
        }
        
        let response = INAddTasksIntentResponse(code: .success, userActivity: nil)
        response.modifiedTaskList = intent.targetTaskList
        response.addedTasks = tasks
        completion(response)
    }
    
}

extension IntentHandler : INSetTaskAttributeIntentHandling {
    
    public func handle(setTaskAttribute intent: INSetTaskAttributeIntent,
                       completion: @escaping (INSetTaskAttributeIntentResponse) -> Swift.Void) {
        
        guard let title = intent.targetTask?.title else {
            completion(INSetTaskAttributeIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        let status = intent.status
        
        if status == .completed {
            ListsManager.sharedInstance.finish(task: title)
        }
        let response = INSetTaskAttributeIntentResponse(code: .success, userActivity: nil)
        response.modifiedTask = intent.targetTask
        completion(response)
    }
    
}
