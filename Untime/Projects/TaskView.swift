//
//  TaskAddView.swift
//  TrackYourTime
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
    
    var body: some View {
        VStack {
            if !editMode {
                CancelSaveView(title: title) {
                    modal.toggle()
                } saveAction: {
                    let newTask = Task(context: viewContext)
                    setTaskInfo(mTask: newTask, isNewTask: true)
                    modal.toggle()
                }
            }
            
            Form {
                TextField("Description", text: $task.description, prompt: Text("Description"))
                DatePicker("Date", selection: $task.date, displayedComponents: .date)
                DatePicker("Time", selection: $task.time, displayedComponents: .hourAndMinute)
            }
        }
        .onDisappear {
            if editMode {
                setTaskInfo(mTask: managedTask!)
                refresherWrapper.refresh.toggle()
            }
        }
    }
    
    func setTaskInfo(mTask: Task, isNewTask: Bool = false) {
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
            if isNewTask {
                managedProject.addToTasks(mTask)
                mTask.project = managedProject
            }
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskAddView_Previews: PreviewProvider {
    @State static var modal = false
    
    static var previews: some View {
        TaskView(modal: $modal, task: TaskModel(), managedProject: Project())
    }
}
