//
//  ProjectAddView.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 07.12.21.
//

import SwiftUI
import CoreData

struct ProjectView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var title = ""
    @ObservedObject var project = ProjectModel()
    @Binding var modal: Bool
    var selectedTags: [SelectedTagWrapper]
    var editMode = false
    var managedProject: Project?
    @StateObject var refresherWrapper = RefresherWrapper()
    
    var body: some View {
        VStack {
            if !editMode {
                CancelSaveView(title: title) {
                    modal.toggle()
                } saveAction: {
                    let newProject = Project(context: viewContext)
                    setProjectInfo(mProject: newProject)
                    modal.toggle()
                }
            }
            
            Form {
                Section("General info") {
                    TextField("Name", text: $project.projectTitle)
                    TextField("Project ID", text: $project.projectId)
                }
                .onTapGesture {
                    self.dismissKeyboard()
                }
                
                Section("Description") {
                    TextEditor(text: $project.description)
                }
                .onTapGesture {
                    self.dismissKeyboard()
                }
                
                Section("Tags") {
                    List {
                        ForEach(selectedTags) {tag in
                            SingleTagSelectionView(selectedTagWrapper: tag)
                        }
                    }
                }
                .onTapGesture {
                    self.dismissKeyboard()
                }

                if (editMode) {
                    Button {
                        viewContext.delete(managedProject!)
                        for task in managedProject!.tasks! {
                            viewContext.delete(task as! NSManagedObject)
                        }
                        do {
                            try viewContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    } label: {
                        Text("Delete project").foregroundColor(.red).bold()
                    }
                    
                    Button {
                        project.active.toggle()
                    } label: {
                        Text(project.active ? "Archive project" : "Reactivate project").bold()
                    }

                    
                    Section("Tasks") {
                        List {
                            let taskList = fetchTasks(mProject: managedProject!)
                            ForEach(taskList) { task in
                                let taskModel = TaskModel.convertManagedTask(task: task)
                                NavigationLink {
                                    TaskView(modal: $modal, task: taskModel, managedProject: managedProject!, editMode: true, managedTask: task, refresherWrapper: refresherWrapper)
                                } label: {
                                    TaskCardView(refresherWrapper: refresherWrapper, task: task)
                                }
                            }
                            .onMove(perform: nil)
                            .onDelete(perform: { indexSet  in
                                let taskToDelete = taskList[indexSet.first!]
                                viewContext.delete(taskToDelete)
                                do {
                                    try viewContext.save()
                                } catch {
                                    print(error.localizedDescription)
                                }
                            })
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    .onTapGesture {
                        self.dismissKeyboard()
                    }

                }
                
            }
        }
        .onDisappear {
            if editMode {
                setProjectInfo(mProject: managedProject!)
            }
        }
        
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
        .navigationTitle(project.projectTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func setProjectInfo(mProject: Project) {
        do {
            mProject.name = project.projectTitle
            mProject.id = project.projectId
            mProject.desc = project.description
            mProject.active = project.active
            for selectedTag in selectedTags {
                if selectedTag.isSelected {
                    mProject.addToTags(selectedTag.boundTag)
                    selectedTag.boundTag.addToProject(mProject)
                } else {
                    mProject.removeFromTags(selectedTag.boundTag)
                    selectedTag.boundTag.removeFromProject(mProject)
                }
            }
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchTasks(mProject: Project) -> [Task] {
        do {
            let fetchRequest : NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "project = %@ AND isFinished = 1", mProject)
            let fetchedTasks = try viewContext.fetch(fetchRequest)
            return fetchedTasks
        } catch {
            print ("fetch task failed", error)
        }
        return []
    }
}

struct ProjectAddView_Previews: PreviewProvider {
    @State static var modal = true
    
    static var previews: some View {
        ProjectView(modal: $modal, selectedTags: [], managedProject: Project())
    }
}
