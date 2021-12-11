//
//  ProjectTagView.swift.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 05.12.21.
//

import SwiftUI

struct ProjectTagView: View {
    @ObservedObject var tag: TagModel
    
    var body: some View {
        Text(tag.tag).bold().foregroundColor(tag.fontColor).padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4)).background(tag.color).cornerRadius(3)
    }
}

struct ProjectTagView_swift_Previews: PreviewProvider {
    static var previews: some View {
        ProjectTagView(tag: TagModel(tag: "LUKB", color: Color.black, fontColor: Color.white, isSelected: false))
    }
}
