//
//  ReportingView.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 06.12.21.
//

import SwiftUI
import CoreData

struct ReportingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var byDateChecked = true
    @State private var selectionTagProject = 0
    @State private var selectionDate = 0
    
    var body: some View {
        NavigationView() {
            VStack {
                HStack(alignment: .top) {
                    VStack {
                        Text("Date level").bold()
                        Picker("Date aggregation", selection: $selectionDate) {
                            Text("First").tag(0)
                            Text("Second").tag(1)
                            Text("None").tag(2)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    VStack {
                        Text("Aggregate by").bold()
                        Picker("Aggregation by", selection: $selectionTagProject) {
                            Text("Project").tag(0)
                            Text("Tag").tag(1)
                        }
                        .pickerStyle(.segmented)
                    }
                }
                .padding()
                
                let taskAggregator = TaskAggregator(data: fetchTasks())
                let aggregatedTasks = taskAggregator.aggregate(dateSelectorLevel: DateSelectorLevel(rawValue: selectionDate)!, aggregationSelector: AggregationSelector(rawValue: selectionTagProject)!)
                let keys: [String] = Array(aggregatedTasks.keys).sorted {$0.localizedStandardCompare($1) == .orderedDescending}
            
                List {
                    ForEach(keys, id: \.self) { key in
                        let value = aggregatedTasks[key]!
                        let subKeys = Array(value.keys).sorted {$0.localizedStandardCompare($1) == .orderedDescending}
                        Section(key) {
                            ForEach(subKeys, id: \.self) { subKey in
                                HStack {
                                    Text(subKey)
                                    Spacer()
                                    Text(value[subKey]!.description)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Reporting")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func fetchTasks() -> [Task] {
        do {
            let fetchRequest : NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isFinished = 1")
            fetchRequest.returnsObjectsAsFaults = false
            let fetchedTasks = try viewContext.fetch(fetchRequest)
            return fetchedTasks
        } catch {
            print ("fetch task failed", error)
        }
        return []
    }
    
    func fetchTags() -> [Tag] {
        print("executing fetching tags")
        do {
            let fetchRequest : NSFetchRequest<Tag> = Tag.fetchRequest()
            fetchRequest.returnsObjectsAsFaults = false
            let fetchedTags = try viewContext.fetch(fetchRequest)
            return fetchedTags
        } catch {
            print ("fetch tags failed", error)
        }
        return []
    }
}

struct ReportingView_Previews: PreviewProvider {
    static var previews: some View {
        ReportingView()
    }
}
