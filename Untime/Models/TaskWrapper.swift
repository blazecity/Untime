//
//  TaskWrapper.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 08.12.21.
//

import Foundation

class TaskWrapper: Identifiable {
    @Published var task: TaskModel
    var boundTask: Task
    
    init(task: TaskModel, boundTask: Task) {
        self.task = task
        self.boundTask = boundTask
    }
    
    static func getCollectionFromFetchingData(tasks: NSSet, filter: TaskFilter = .all) -> [TaskWrapper] {
        var collection: [TaskWrapper] = []
        for task in tasks {
            let t = task as! Task
            switch filter {
            case .all:
                break
            case .finished:
                if !t.isFinished { continue }
            case .unfinished:
                if t.isFinished { continue }
            }
            let hoursAndSeconds = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: t.date!)!
            let taskModel = TaskModel(description: t.name!, seconds: Int(t.seconds), isFinished: t.isFinished, date: t.date!, time: hoursAndSeconds)
            let taskWrapper = TaskWrapper(task: taskModel, boundTask: t)
            collection.append(taskWrapper)
        }
        return collection
    }

}
