//
//  TaskModel.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 06.12.21.
//

import Foundation

class TaskModel: ObservableObject, Identifiable {
    @Published var description: String
    @Published var seconds: Int
    @Published var isFinished: Bool
    @Published var date: Date
    @Published var time: Date
    @Published var lastActive: Date
    @Published var running: Bool
    
    convenience init() {
        self.init(description: "")
    }
    
    convenience init(isFinished: Bool) {
        self.init(description: "")
        self.isFinished = isFinished
    }
    
    convenience init(description: String) {
        let zeroTime = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        self.init(description: description, seconds: 0, isFinished: false, date: Date(), time: zeroTime)
    }
    
    init(description: String, seconds: Int, isFinished: Bool, date: Date, time: Date) {
        self.description = description
        self.seconds = seconds
        self.isFinished = isFinished
        self.date = date
        self.time = time
        self.lastActive = Date()
        self.running = false
    }
    
    static func getCollectionFromFetchingData(tasks: NSSet, filter: TaskFilter = .all) -> [TaskModel] {
        var collection: [TaskModel] = []
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
            let taskModel = convertManagedTask(task: t)
            collection.append(taskModel)
        }
        return collection
    }
    
    static func convertManagedTask(task: Task) -> TaskModel {
        let newTaskModel = TaskModel()
        
        guard let name = task.name else { return newTaskModel }
        guard let date = task.date else { return newTaskModel }
        
        newTaskModel.description = name
        newTaskModel.date = date
        newTaskModel.isFinished = task.isFinished
        newTaskModel.seconds = Int(task.seconds)
        let (hours, minutes, seconds) = TimerManager.getHoursMinutesSeconds(seconds: Int(task.seconds))
        let hoursAndSeconds = Calendar.current.date(bySettingHour: hours, minute: minutes, second: seconds, of: Date())!
        newTaskModel.time = hoursAndSeconds
        
        return newTaskModel
    }
}
