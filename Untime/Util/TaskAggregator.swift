//
//  TaskAggregator.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 11.12.21.
//

import Foundation

enum DateSelectorLevel {
    case first
    case second
    case none
}

enum AggregationSelector {
    case tag
    case project
}

class TaskAggregator {
    private var data: [Task]
    
    init(data: [Task]) {
        self.data = data
    }
    
    func aggregate(dateSelectorLevel: DateSelectorLevel, aggregationSelector: AggregationSelector) -> [String: [String]] {
        let map: [String: [String]] = [:]
        return map
    }
    
    private func aggregateBy(tasks: [Task], aggregationSelector: AggregationSelector) {
        var map: [String: Int] = [:]
        for task in tasks {
            var value = 0
            switch (aggregationSelector) {
            case .project:
                //value = map[task.project!.name!]
                break
                
            case .tag:
                break
                // achtung mehrere Tags pro Project
                
                //value = map[task.tag1]
            }
            //let key = map[]
        }
    }
    
    private func getTasksByDate() -> [Date: [Task]] {
        var map: [Date: [Task]] = [:]
        for task in self.data {
            let collection = map[task.date!]
            guard var col = collection else {
                map[task.date!] = [task]
                continue
            }
            col.append(task)
        }
        return map
    }
}
