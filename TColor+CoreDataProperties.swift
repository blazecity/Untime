//
//  TColor+CoreDataProperties.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 08.12.21.
//
//

import Foundation
import CoreData


extension TColor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TColor> {
        return NSFetchRequest<TColor>(entityName: "TColor")
    }

    @NSManaged public var blue: Double
    @NSManaged public var green: Double
    @NSManaged public var red: Double
    @NSManaged public var alpha: Double
    @NSManaged public var tagColor: Tag?
    @NSManaged public var tagFontColor: Tag?

}

extension TColor : Identifiable {

}
