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
    @State var buttonPlay = "play"
    @ObservedObject var refresherWrapper: RefresherWrapper
    @State var color = CustomColor(rgb: [220, 220, 220])
    @State var foregroundColor = Color.black
    @State var inactiveDate = Date()
    
    var body: some View {
        HStack(alignment: .center) {
            Button {
                toggleButton()
                if buttonPlay == "play" {
                    saveTime()
                }
            } label: {
                Image(systemName: buttonPlay)
                    .font(Font.title.weight(.medium))
                    .foregroundColor(foregroundColor)
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
                    .foregroundColor(foregroundColor)
                    .padding(.trailing, 2)
            }
            
            VStack(alignment: .leading) {
                CustomText(text: $timer.formattedTime, size: 15, bold: true, color: foregroundColor)
                CustomText(text: $task.description, size: 12, color: foregroundColor).lineLimit(1)
            }
            .padding(2)
        }
        .frame(minWidth: 140, maxWidth: 160, alignment: .leading)
        .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
        .background(color)
        .cornerRadius(5)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                inactiveDate = Date()
            } else if newPhase == .active {
                let diff = Int(Date().timeIntervalSince(inactiveDate))
                timer.addSeconds(increase: diff)
                saveTime()
            }
        }
    }
    
    func toggleButton() {
        if buttonPlay == "play" {
            color = CustomColor(rgb: [44, 54, 79])
            foregroundColor = .white
            buttonPlay = "pause"
            timer.start()
        } else {
            color = CustomColor(rgb: [220, 220, 220])
            foregroundColor = .black
            buttonPlay = "play"
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
