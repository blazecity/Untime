//
//  TagAddView.swift.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 08.12.21.
//

import SwiftUI

struct TagView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var title = ""
    @ObservedObject var tag = TagModel()
    @Binding var modal: Bool
    @State var showAlert = false
    var editMode = false
    var managedTag: Tag?
    
    var body: some View {
        VStack {
            if !editMode {
                CancelSaveView(title: title) {
                    modal.toggle()
                } saveAction: {
                    let newTag = Tag(context: viewContext)
                    setTagInfo(mTag: newTag)
                    modal.toggle()
                }
            }
            
            Form {
                TextField("Tag name", text: $tag.tag, prompt: Text("Tag name"))
                
                ColorPicker(selection: $tag.color) {
                    Text("Background color")
                }
                ColorPicker(selection: $tag.fontColor) {
                    Text("Font color")
                }
            }
            .alert("Please enter a tag name", isPresented: $showAlert) {
                Button("Ok", role: .cancel) {
                    
                }
            }
        }
        .onDisappear {
            if editMode {
                setTagInfo(mTag: managedTag!)
            }
        }
    }
    
    func setTagInfo(mTag: Tag) {
        let tagName = tag.tag.trimmingCharacters(in: .whitespaces)
        guard tagName.split(separator: " ").count != 0 else {
            showAlert = true
            return
        }
        let newColor = ColorConverter.convertToTColor(tag.color, viewContext: viewContext)
        let newFontColor = ColorConverter.convertToTColor(tag.fontColor, viewContext: viewContext)
        do {
            
            mTag.name = tag.tag
            mTag.color = newColor
            mTag.fontColor = newFontColor
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TagAddView_swift_Previews: PreviewProvider {
    @State static var modal = true
    
    static var previews: some View {
        TagView(modal: $modal, managedTag: Tag())
    }
}
