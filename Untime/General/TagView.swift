//
//  TagAddView.swift.swift
//  Untime
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
                    let validationSuccessful = saveTag(mTag: newTag)
                    if validationSuccessful {
                        modal.toggle()
                    }
                }
            }
            
            Form {
                TextField(String(localized: "label_txt_field_tag_name"), text: $tag.tag, prompt: Text(String(localized: "label_txt_field_tag_name")))
                
                ColorPicker(selection: $tag.color) {
                    Text(String(localized: "label_tag_background_color"))
                }
                ColorPicker(selection: $tag.fontColor) {
                    Text(String(localized: "label_tag_font_color"))
                }
            }
            .alert(String(localized: "validation_message"), isPresented: $showAlert) {
                Button("Ok", role: .cancel) {
                    
                }
            }
        }
        .onDisappear {
            if editMode {
                let validationSuccessful = saveTag(mTag: managedTag!)
                if !validationSuccessful {
                    resetTag(mTag: managedTag!)
                }
            }
        }
    }
    
    func saveTag(mTag: Tag) -> Bool {
        guard StringValidator.validate(str: tag.tag) else {
            showAlert = true
            return false
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
            return false
        }
        
        return true
    }
    
    func resetTag(mTag: Tag) {
        tag.tag = mTag.name!
    }
}

struct TagAddView_swift_Previews: PreviewProvider {
    @State static var modal = true
    
    static var previews: some View {
        TagView(modal: $modal, managedTag: Tag())
    }
}
