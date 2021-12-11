//
//  ProjectsView.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 05.12.21.
//

import SwiftUI

struct ProjectsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var modal = false
    
    @FetchRequest(entity: Project.entity(), sortDescriptors: [])
    var projects: FetchedResults<Project>
    
    @FetchRequest(entity: Tag.entity(), sortDescriptors: [])
    var tags: FetchedResults<Tag>
    
    var body: some View {
        NavigationView() {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(projects) {project in
                        let projectModel = ProjectModel.convertManagedProject(project: project)
                        
                        NavigationLink(destination: ProjectView(project: projectModel, modal: $modal, selectedTags: SelectedTagWrapper.getCollectionFromFetchingData(tags: tags, selectedTags: project.tags!), editMode: true, managedProject: project))
                        {
                            ProjectItemView(passedProject: projectModel, managedProject: project)
                        }
                        .isDetailLink(false)
                        .buttonStyle(.plain)
                    }
                }
                .frame(
                      minWidth: 0,
                      maxWidth: .infinity,
                      minHeight: 0,
                      maxHeight: .infinity,
                      alignment: .topLeading
                )
                .navigationBarTitle("Projects")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button(action: {
                        modal.toggle()
                    },
                    label: {
                        Image(systemName: "plus.circle")
                            .padding(10)
                    })
                    .sheet(isPresented: $modal) {
                    ProjectView(title: "Add new project", modal: $modal, selectedTags: SelectedTagWrapper.getCollectionFromFetchingData(tags: tags, selectedTags: []))
                    }
                )
            }
            .background(CustomColor(rgb: [248, 248, 248], opacity: 1))
        }
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView()
    }
}
