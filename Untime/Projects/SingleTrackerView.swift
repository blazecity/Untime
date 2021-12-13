//
//  SingleTrackerView.swift.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 06.12.21.
//

import SwiftUI

struct SingleTrackerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.scenePhase) var scenePhase
    
    @ObservedObject var task: TaskModel
    var managedTask: Task
    @ObservedObject var timer = TimerManager()
    @ObservedObject var refresherWrapper: RefresherWrapper
    @State var inactiveDate = Date()
    
    var body: some View {
        HStack(alignment: .center) {
            Button {
                toggleButton()
                if !managedTask.running {
                    saveTime()
                }
            } label: {
                Image(systemName: managedTask.running ? "pause": "play")
                    .font(Font.title.weight(.medium))
                    .foregroundColor(managedTask.running ? .white : .black)
                    .padding(.trailing, 2)
            }
            
            Button {
                task.isFinished = true
                managedTask.isFinished = true
                do {
                    try viewContext.save()
                    refresherWrapper.refresh.toggle()
                } catch {
                    print(error.localizedDescription)
                }
            } label: {
                Image(systemName: ("stop"))
                    .font(Font.title.weight(.medium))
                    .foregroundColor(managedTask.running ? .white : .black)
                    .padding(.trailing, 2)
            }
            
            VStack(alignment: .leading) {
                CustomText(text: $timer.formattedTime, size: 15, bold: true, color: managedTask.running ? .white : .black)
                CustomText(text: $task.description, size: 12, color: managedTask.running ? .white : .black).lineLimit(1)
            }
            .padding(2)
        }
        .frame(minWidth: 140, maxWidth: 160, alignment: .leading)
        .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
        .background(managedTask.running ? CustomColor(rgb: [44, 54, 79]) : CustomColor(rgb: [220, 220, 220]))
        .cornerRadius(5)
        .onChange(of: scenePhase) { newPhase in
            print(newPhase)
            if newPhase == .background {
                inactiveDate = Date()
                managedTask.lastActive = inactiveDate
                saveTime()
            } else if newPhase == .active {
                if managedTask.running {
                    let diff = Int(Date().timeIntervalSince(inactiveDate))
                    timer.addSeconds(increase: diff)
                    saveTime()
                }
            }
        }
        .onDisappear {
            if managedTask.running {
                managedTask.lastActive = Date()
                saveTime()
            }
        }
    }
    
    func toggleButton() {
        if !managedTask.running {
            managedTask.running = true
            timer.start()
        } else {
            managedTask.running = false
            timer.interrupt()
        }
    }
    
    func saveTime() {
        task.seconds = Int(timer.time)
        managedTask.seconds = Int32(timer.time)
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct SingleTrackerView_swift_Previews: PreviewProvider {
    @StateObject static var refresh = RefresherWrapper()
    static var previews: some View {
        SingleTrackerView(task: TaskModel(), managedTask: Task(), refresherWrapper: refresh)
    }
}
