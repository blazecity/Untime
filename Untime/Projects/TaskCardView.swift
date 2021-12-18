//
//  TaskCardFile.swift
//  Untime
//
//  Created by Jan Baumann on 10.12.21.
//

import SwiftUI

struct TaskCardView: View {
    @ObservedObject var refresherWrapper: RefresherWrapper
    var task: Task
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(task.name!).bold()
            Text(Formatter.formatDate(date: task.date!)).font(.system(size: 10))
            Text(TimerManager.formatTime(newValue: Int(task.seconds))).font(.system(size: 10))
        }
    }
}

struct TaskCardFile_Previews: PreviewProvider {
    @StateObject static var task = Task()
    
    static var previews: some View {
        TaskCardView(refresherWrapper: RefresherWrapper(), task: task)
    }
}
