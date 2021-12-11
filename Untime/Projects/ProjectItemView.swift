//
//  ProjectsViewItem.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 05.12.21.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .background(
                Circle()
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 0)
            )
    }
}

struct ProjectItemView: View {
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
                    
                    CustomText(text: $passedProject.description, size: 12, bold: false, color: .black).padding(.bottom, 3)
                    HStack {
                        ForEach(passedProject.tags) { tag in
                            ProjectTagView(tag: tag)
                        }
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(TaskWrapper.getCollectionFromFetchingData(tasks: managedProject.tasks!, filter: .unfinished)) {task in
                                SingleTrackerView(task: task.task, managedTask: task.boundTask, timer: TimerManager(time: Int(task.boundTask.seconds)), refresherWrapper: refresherWrapper)
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
                .background(Color.white)
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
                    TaskView(title: "Add complete task", modal: $modalCompletedTask, task: taskModel, managedProject: managedProject, managedTask: managedTask, refresherWrapper: refresherWrapper)
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
                    TaskView(title: "Add fresh timer", modal: $modalFreshTimer, task: taskModel, managedProject: managedProject)
                }
            }
            .padding(.trailing, 35)
            .buttonStyle(CustomButtonStyle())
            .offset(x: 0, y: 20)
        }
        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 0)
        .padding(EdgeInsets(top: 30, leading: 10, bottom: 0, trailing: 10))
    }
}

struct ProjectsViewItem_Previews: PreviewProvider {
    static var previews: some View {
        ProjectItemView(passedProject: ProjectModel(projectTitle: "Fondssparplan",
                                                     tags: [
                                                        TagModel(tag: "LUKB", color: Color.blue, fontColor: Color.white, isSelected: false)
                                                     ],
                                                     tasks: [
                                                        TaskModel(description: "Hello")
                                                     ],
                                                     projectId: "PI-414",
                                                     description: "Fondssparplan LUKB"), managedProject: Project())
    }
}
