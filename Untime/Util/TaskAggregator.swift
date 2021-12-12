//
//  TaskAggregator.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 11.12.21.
//

import Foundation

enum DateSelectorLevel: Int {
    case first
    case second
    case none
}

enum AggregationSelector: Int {
    case project
    case tag
}

protocol Summable {
    
}

class TaskAggregator {
    private var data: [Task]
    
    init(data: [Task]) {
        self.data = data
    }
    
    func aggregate(dateSelectorLevel: DateSelectorLevel, aggregationSelector: AggregationSelector) -> [String: [String: Double]] {
        var map: [String: [String: Double]] = [:]
        switch (dateSelectorLevel) {
        case .first:
            let m = mapTasksByDate(tasks: data)
            for (subCollKey, subCollValue) in m {
                let reducedValue = reduce(subCollection: subCollValue, to: aggregationSelector)
                map[subCollKey] = reducedValue
            }
            break
            
        case .second:
            let m = mapTask(tasks: data, by: aggregationSelector)
            for (subCollKey, subCollValue) in m {
                let reducedValue = reduceToDate(subCollection: subCollValue)
                map[subCollKey] = reducedValue
            }
            break
            
        case .none:
            let m = mapTask(tasks: data, by: aggregationSelector)
            for (subCollKey, subCollValue) in m {
                let reducedValue = [subCollKey: reduceDirectly(subCollection: subCollValue)]
                map[subCollKey] = reducedValue
            }
            break
        }
        return map
    }
    
    private func mapTasksByDate(tasks: [Task]) -> [String: [Task]] {
        var map: [String: [Task]] = [:]
        for task in tasks {
            let formattedDate = Formatter.formatDate(date: task.date!)
            if var arr = map[formattedDate] {
                arr.append(task)
                map[formattedDate] = arr
            } else {
                map[formattedDate] = [task]
            }
        }
        return map
    }
    
    private func calcHours(seconds: Int32) -> Double {
        return (Double(seconds / 1800) * 0.5)
    }
    
    private func reduceToDate(subCollection: [Task]) -> [String: Double] {
        var map: [String: Double] = [:]
        for task in subCollection {
            let hours = calcHours(seconds: task.seconds)
            let formattedDate = Formatter.formatDate(date: task.date!)
            if let aggrTime = map[formattedDate] {
                map[formattedDate] = aggrTime + hours
            } else {
                map[formattedDate] = hours
            }
        }
        return map
    }
    
    private func reduceDirectly(subCollection: [Task]) -> Double {
        var hours = 0.0
        for task in subCollection {
            hours += calcHours(seconds: task.seconds)
        }
        return hours
    }
    
    private func mapTask(tasks: [Task], by: AggregationSelector) -> [String: [Task]] {
        var map: [String: [Task]] = [:]
        
        switch (by) {
        case .project:
            for task in tasks {
                let project = task.project!
                if var arr = map[project.name!] {
                    arr.append(task)
                    map[project.name!] = arr
                } else {
                    map[project.name!] = [task]
                }
            }
            break
            
        case .tag:
            for task in tasks {
                let tags = task.project!.tags!
                for tag in tags {
                    let t = tag as! Tag
                    if var arr = map[t.name!] {
                        arr.append(task)
                        map[t.name!] = arr
                    } else {
                        map[t.name!] = [task]
                    }
                }
            }
            break
        }
        
        return map
    }
    
    private func reduce(subCollection: [Task], to: AggregationSelector) -> [String: Double] {
        var map: [String: Double] = [:]
        switch (to) {
        case .project:
            for task in subCollection {
                let project = task.project!
                let taskHours = calcHours(seconds: task.seconds)
                if let hours = map[project.name!] {
                    map[project.name!] = hours + taskHours
                } else {
                    map[project.name!] = taskHours
                }
            }
            break
            
        case .tag:
            for task in subCollection {
                let tags = task.project!.tags!
                let taskHours = calcHours(seconds: task.seconds)
                for tag in tags {
                    let t = tag as! Tag
                    if let hours = map[t.name!] {
                        map[t.name!] = hours + taskHours
                    } else {
                        map[t.name!] = taskHours
                    }
                }
            }
            break
        }
        return map
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
