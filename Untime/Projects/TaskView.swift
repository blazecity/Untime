//
//  TaskAddView.swift
//  Untime
//
//  Created by Jan Baumann on 08.12.21.
//

import SwiftUI

struct TaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var title = ""
    @Binding var modal: Bool
    @ObservedObject var task: TaskModel
    var managedProject: Project
    var editMode = false
    var managedTask: Task?
    @ObservedObject var refresherWrapper: RefresherWrapper = RefresherWrapper()
    @State var showAlert = false
    
    
    var body: some View {
        VStack {
            if !editMode {
                CancelSaveView(title: title) {
                    modal.toggle()
                } saveAction: {
                    let newTask = Task(context: viewContext)
                    let validationSuccessful = saveTask(mTask: newTask, isNewTask: true)
                    if validationSuccessful {
                        modal.toggle()
                        refresherWrapper.refresh.toggle()
                    }
                }
                .alert(String(localized: "project_validation_text"), isPresented: $showAlert) {
                    Button("Ok", role: .cancel) {
                        
                    }
                }
            }
            
            Form {
                TextField("Description", text: $task.description, prompt: Text(String(localized: "label_task_desc")))
                DatePicker(String(localized: "label_task_date"), selection: $task.date, displayedComponents: .date)
                DatePicker(String(localized: "label_task_time"), selection: $task.time, displayedComponents: .hourAndMinute)
            }
        }
        .onDisappear {
            if editMode {
                let validationSuccessful = saveTask(mTask: managedTask!)
                if validationSuccessful {
                    refresherWrapper.refresh.toggle()
                } else {
                    resetTask(mTask: managedTask!)
                }
            }
        }
    }
    
    func saveTask(mTask: Task, isNewTask: Bool = false) -> Bool {
        guard StringValidator.validate(str: task.description) else {
            showAlert = true
            return false
        }
        
        do {
            let cal = Calendar.current
            let minutes = cal.component(.minute, from: task.time)
            let hours = cal.component(.hour, from: task.time)
            let seconds = minutes * 60 + hours  * 3600
            task.seconds = seconds
            mTask.seconds = Int32(seconds)
            mTask.name = task.description
            mTask.isFinished = task.isFinished
            mTask.date = task.date
            mTask.running = task.running
            mTask.lastActive = task.lastActive
            if isNewTask {
                managedProject.addToTasks(mTask)
                mTask.project = managedProject
            }
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        return true
    }
    
    func resetTask(mTask: Task) {
        task.description = mTask.description
    }
}

struct TaskAddView_Previews: PreviewProvider {
    @State static var modal = false
    
    static var previews: some View {
        TaskView(modal: $modal, task: TaskModel(), managedProject: Project())
    }
}
