//
//  Tag+CoreDataProperties.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 08.12.21.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var name: String?
    @NSManaged public var color: TColor?
    @NSManaged public var fontColor: TColor?
    @NSManaged public var project: NSSet?

}

// MARK: Generated accessors for project
extension Tag {

    @objc(addProjectObject:)
    @NSManaged public func addToProject(_ value: Project)

    @objc(removeProjectObject:)
    @NSManaged public func removeFromProject(_ value: Project)

    @objc(addProject:)
    @NSManaged public func addToProject(_ values: NSSet)

}

extension Tag : Identifiable {

}

extension Tag : Summable {
    
}
