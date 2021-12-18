//
//  SelectedTagWrapper.swift
//  Untime
//
//  Created by Jan Baumann on 08.12.21.
//

import Foundation
import SwiftUI

class SelectedTagWrapper: ObservableObject, Identifiable {
    
    @Published var isSelected = false
    @Published var tag: TagModel
    var boundTag: Tag
    
    init(tag: TagModel, boundTag: Tag) {
        self.tag = tag
        self.boundTag = boundTag
    }
    
    static func getCollectionFromFetchingData(tags: FetchedResults<Tag>, selectedTags: NSSet) -> [SelectedTagWrapper] {
        var collection: [SelectedTagWrapper] = []
        for tag in tags {
            guard let name = tag.name else { continue }
            guard let color = tag.color else { continue }
            guard let fontColor = tag.fontColor else { continue }
            let tagModel = TagModel(tag: name, color: ColorConverter.convertFromTColor(color), fontColor: ColorConverter.convertFromTColor(fontColor), isSelected: false)
            let selectedTagWrapper = SelectedTagWrapper(tag: tagModel, boundTag: tag)
            if selectedTags.contains(tag) {
                selectedTagWrapper.isSelected = true
            }
            collection.append(selectedTagWrapper)
        }
        return collection
    }
}
