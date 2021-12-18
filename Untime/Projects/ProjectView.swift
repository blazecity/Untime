//
//  ProjectAddView.swift
//  Untime
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
    @ObservedObject var refresherWrapper = RefresherWrapper()
    @State var showAlert = false
    
    var body: some View {
        VStack {
            if !editMode {
                CancelSaveView(title: title) {
                    modal.toggle()
                } saveAction: {
                    let newProject = Project(context: viewContext)
                    let validationSuccessful = saveProject(mProject: newProject)
                    if validationSuccessful {
                        refresherWrapper.refresh.toggle()
                        modal.toggle()
                    }
                }
                .alert(String(localized: "project_validation_text"), isPresented: $showAlert) {
                    Button("Ok", role: .cancel) {
                        
                    }
                }
            }
            
            Form {
                Section(String(localized: "section_title_general_info")) {
                    TextField(String(localized: "label_txt_field_project_name"), text: $project.projectTitle)
                    TextField(String(localized: "label_txt_field_project_id"), text: $project.projectId)
                }
                .onTapGesture {
                    self.dismissKeyboard()
                }
                
                Section(String(localized: "section_title_desc")) {
                    TextEditor(text: $project.description)
                }
                .onTapGesture {
                    self.dismissKeyboard()
                }
                
                Section(String(localized: "section_title_tags")) {
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
                        for task in managedProject!.tasks! {
                            viewContext.delete(task as! NSManagedObject)
                        }
                        viewContext.delete(managedProject!)
                        do {
                            try viewContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    } label: {
                        Text(String(localized: "button_delete_project")).foregroundColor(.red).bold()
                    }
                    
                    Button {
                        project.active.toggle()
                        
                    } label: {
                        Text(project.active ? String(localized: "button_archive_project") : String(localized: "button_reactivate_project")).bold()
                    }
                    
                    Section(String(localized: "section_title_tasks")) {
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
                let validationSuccessful = saveProject(mProject: managedProject!)
                if !validationSuccessful {
                    resetProject(mProject: managedProject!)
                }
            }
        }
        
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
        .navigationTitle(project.projectTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func saveProject(mProject: Project) -> Bool {
        guard StringValidator.validate(strArr: [project.projectTitle, project.projectId, project.description]) else {
            showAlert = true
            return false
        }
        
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
            return false
        }
        
        return true
    }
    
    func resetProject(mProject: Project) {
        project.projectTitle = mProject.name!
        project.projectId = mProject.id!
        project.description = mProject.desc!
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
        ProjectView(modal: $modal, selectedTags: [], managedProject: Project(), refresherWrapper: RefresherWrapper())
    }
}
