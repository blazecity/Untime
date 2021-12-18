//
//  ProjectsViewItem.swift
//  Untime
//
//  Created by Jan Baumann on 05.12.21.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    var backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .background(
                Circle()
                    .fill(backgroundColor)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 0)
            )
    }
}

struct ProjectItemView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var passedProject: ProjectModel
    var managedProject: Project
    @State var trackers: [TaskModel] = []
    @State var modalFreshTimer = false
    @State var modalCompletedTask = false
    @StateObject var refresherWrapper = RefresherWrapper()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(passedProject.projectTitle).font(.system(size: 17)).bold().padding(.bottom, 1)
                        Spacer()
                        Text(passedProject.projectId).bold().padding(3).foregroundColor(.white).background(.black).cornerRadius(5)
                    }
                    Text(passedProject.description).font(.system(size: 12)).padding(.bottom, 3)
                    HStack {
                        ForEach(passedProject.tags) { tag in
                            ProjectTagView(tag: tag)
                        }
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(TaskWrapper.getCollectionFromFetchingData(tasks: managedProject.tasks!, filter: .unfinished)) {task in
                                
                                let managedTask = task.boundTask
                                let diff = managedTask.running ? Int(Date().timeIntervalSince(managedTask.lastActive!)) : 0
                                
                                let timerManager = TimerManager(time: Int(task.boundTask.seconds) + diff, running: task.boundTask.running)
                                                                
                                SingleTrackerView(task: task.task, managedTask: managedTask, timer: timerManager, refresherWrapper: refresherWrapper)
                            }
                        }
                    }
                    .padding(.bottom, 10)
                }
                .frame(
                      minWidth: 0,
                      maxWidth: .infinity,
                      minHeight: 0,
                      alignment: .topLeading
                )
                .padding(EdgeInsets(top: 9, leading: 9, bottom: 25, trailing: 9))
                .background(colorScheme == .dark ? CustomColor(rgb: [35, 35, 35], opacity: 1) : CustomColor(rgb: [255, 255, 255], opacity: 1))
                .cornerRadius(15)
            }
            
            HStack(spacing: 20) {
                Button(action: {
                    modalCompletedTask.toggle()
                }) {
                    Image(systemName: "note.text.badge.plus")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $modalCompletedTask) {
                    let taskModel = TaskModel(isFinished: true)
                    let managedTask = Task(context: viewContext)
                    TaskView(title: String(localized: "add_complete_task_title"), modal: $modalCompletedTask, task: taskModel, managedProject: managedProject, managedTask: managedTask, refresherWrapper: refresherWrapper)
                }

                Button(action: {
                    modalFreshTimer.toggle()
                }) {
                    Image(systemName: "stopwatch")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $modalFreshTimer) {
                    let taskModel = TaskModel()
                    TaskView(title: String(localized: "add_new_task_title"), modal: $modalFreshTimer, task: taskModel, managedProject: managedProject, refresherWrapper: refresherWrapper)
                }
            }
            .padding(.trailing, 35)
            .buttonStyle(CustomButtonStyle(backgroundColor: colorScheme == .dark ? .black : .white
                                          ))
            .offset(x: 0, y: 20)
        }
        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 0)
        .padding(EdgeInsets(top: 30, leading: 10, bottom: 30, trailing: 10))
    }
}

struct ProjectsViewItem_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static private var viewContext
    
    static var previews: some View {
        ProjectItemView(passedProject: ProjectModel(projectTitle: "Fondssparplan",
                                                     tags: [
                                                        TagModel(tag: "LUKB", color: Color.blue, fontColor: Color.white, isSelected: false)
                                                     ],
                                                     tasks: [
                                                        TaskModel(description: "Hello")
                                                     ],
                                                     projectId: "PI-414",
                                                    description: "Fondssparplan LUKB"), managedProject: Project(context: viewContext), refresherWrapper: RefresherWrapper())
    }
}
