//
//  SingleTagSelectionVIew.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 08.12.21.
//

import SwiftUI

struct SingleTagSelectionView: View {
    @ObservedObject var selectedTagWrapper: SelectedTagWrapper
    
    var body: some View {
        HStack() {
            ProjectTagView(tag: selectedTagWrapper.tag)
            Spacer()
            if selectedTagWrapper.isSelected {
                Image(systemName: "checkmark")
            }
        }
        .background(Color.white)
        .onTapGesture {
            selectedTagWrapper.isSelected.toggle()
        }
    }
}

struct SingleTagSelectionVIew_Previews: PreviewProvider {
    static let tag = SelectedTagWrapper(tag: TagModel(tag: "Hello", color: .blue, fontColor: .white, isSelected: false), boundTag: Tag())
    
    static var previews: some View {
        SingleTagSelectionView(selectedTagWrapper: tag)
    }
}
