//
//  TagModel.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 05.12.21.
//

import Foundation
import SwiftUI

class TagModel: ObservableObject, Identifiable {
    var id: String {
        tag
    }
    
    @Published var tag: String
    @Published var color: Color
    @Published var fontColor: Color
    @Published var isSelected: Bool
    
    init() {
        self.tag = ""
        self.color = .blue
        self.fontColor = .white
        self.isSelected = false
    }
       
    init(tag: String, color: Color, fontColor: Color, isSelected: Bool) {
        self.tag = tag
        self.color = color
        self.fontColor = fontColor
        self.isSelected = isSelected
    }
    
    static func getCollectionFromFetchingData(tags: NSSet) -> [TagModel] {
        var collection: [TagModel] = []
        for tag in tags {
            let t = tag as! Tag
            collection.append(convertManagedTag(mTag: t))
        }
        return collection
    }
    
    static func convertManagedTag(mTag: Tag) -> TagModel {
        return TagModel(tag: mTag.name!, color: ColorConverter.convertFromTColor(mTag.color!), fontColor: ColorConverter.convertFromTColor(mTag.fontColor!), isSelected: false)
    }
}
