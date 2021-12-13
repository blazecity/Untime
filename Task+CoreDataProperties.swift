//
//  Task+CoreDataProperties.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 08.12.21.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var seconds: Int32
    @NSManaged public var date: Date?
    @NSManaged public var lastActive: Date?
    @NSManaged public var isFinished: Bool
    @NSManaged public var running: Bool
    @NSManaged public var project: Project?

}

extension Task : Identifiable {

}
