//
//  TagListView.swift
//  Untime
//
//  Created by Jan Baumann on 08.12.21.
//

import SwiftUI

struct TagListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Tag.entity(), sortDescriptors: [])
    var tags: FetchedResults<Tag>
    
    @State var modal = false
    
    var body: some View {
        List {
            ForEach(SelectedTagWrapper.getCollectionFromFetchingData(tags: tags, selectedTags: [])) { tag in
                NavigationLink(destination: TagView(tag: tag.tag, modal: $modal, editMode: true, managedTag: tag.boundTag))
                {
                    ProjectTagView(tag: tag.tag)
                }.buttonStyle(.plain)
            }
            .onDelete { indexSet in
                let tagToDelete = tags[indexSet.first!]
                viewContext.delete(tagToDelete.color!)
                viewContext.delete(tagToDelete.fontColor!)
                viewContext.delete(tagToDelete)
                do {
                    try viewContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .navigationBarItems(trailing: Button(action: {
                modal.toggle()
            },
            label: {
                Image(systemName: "plus.circle")
                    .padding(10)
            })
            .sheet(isPresented: $modal) {
            TagView(title: String(localized: "add_new_tag_title"), modal: $modal)
            }
        )
        .navigationBarTitle(String(localized: "list_title_tags"))
    }
}

struct TagListView_Previews: PreviewProvider {
    static var previews: some View {
        TagListView()
    }
}
