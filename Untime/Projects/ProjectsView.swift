import SwiftUI
import CoreData

/// ProjectsView represents the first tab with the overview of all projects.
struct ProjectsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var modal = false
    
    @FetchRequest(entity: Tag.entity(), sortDescriptors: [])
    var tags: FetchedResults<Tag>
    
    @FetchRequest(entity: Project.entity(), sortDescriptors: [], predicate: NSPredicate(format: "active = 1"))
    var activeProjects: FetchedResults<Project>
    
    @FetchRequest(entity: Project.entity(), sortDescriptors: [], predicate: NSPredicate(format: "active = 0"))
    var inactiveProjects: FetchedResults<Project>
    
    @State var selectedProjectStatus = 1
    
    var body: some View {
        NavigationView() {
            VStack {
                Picker("Project status", selection: $selectedProjectStatus) {
                    Text(String(localized: "picker_option_active_projects")).tag(1)
                    Text(String(localized: "picker_option_archived_projects")).tag(0)
                }
                .pickerStyle(.segmented)
                .padding()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: -5) {
                        ForEach(selectedProjectStatus == 0 ? inactiveProjects : activeProjects) {project in
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
                    .navigationBarTitle(String(localized: "tab_projects_title"))
                    //.navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(trailing: Button(action: {
                            modal.toggle()
                        },
                        label: {
                            Image(systemName: "plus.circle")
                                .padding(10)
                        })
                        .sheet(isPresented: $modal) {
                        ProjectView(title: String(localized: "add_project_title"), modal: $modal, selectedTags: SelectedTagWrapper.getCollectionFromFetchingData(tags: tags, selectedTags: []))
                        }
                    )
                }
                .background(colorScheme == .dark ? CustomColor(rgb: [56, 56, 56], opacity: 1) : CustomColor(rgb: [248, 248, 248], opacity: 1))
            }
        }
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView()
    }
}
