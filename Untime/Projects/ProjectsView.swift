//
//  ProjectsView.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 05.12.21.
//

import SwiftUI
import CoreData

struct ProjectsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var modal = false
    
    @FetchRequest(entity: Project.entity(), sortDescriptors: [])
    var projects: FetchedResults<Project>
    
    @FetchRequest(entity: Tag.entity(), sortDescriptors: [])
    var tags: FetchedResults<Tag>
    
    @State var selectedProjectStatus = 1
    
    var body: some View {
        NavigationView() {
            VStack {
                Picker("Project status", selection: $selectedProjectStatus) {
                    Text("Active Projects").tag(1)
                    Text("Archive").tag(0)
                }
                .pickerStyle(.segmented)
                .padding()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(fetchProjects()) {project in
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
    
    func fetchProjects() -> [Project] {
        do {
            let fetchRequest : NSFetchRequest<Project> = Project.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "active = \(selectedProjectStatus)")
            let fetchedProjects = try viewContext.fetch(fetchRequest)
            return fetchedProjects
        } catch {
            print ("fetch task failed", error)
        }
        return []
    }
     
}

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView()
    }
}
