//
//  ReportingView.swift
//  Untime
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
    @State private var fromDate = Date()
    @State private var toDate = Date()
    @State private var showAlert = false
    @StateObject var refresherWrapper: RefresherWrapper
    
    @FetchRequest(entity: Task.entity(), sortDescriptors: [], predicate: NSPredicate(format: "isFinished = 1 and project.active = 1"))
    var tasks: FetchedResults<Task>
    
    var body: some View {
        NavigationView() {
            VStack {
                HStack(alignment: .top) {
                    VStack {
                        Text(String(localized: "title_date_aggregator")).bold()
                        Picker("Date aggregation", selection: $selectionDate) {
                            Text(String(localized: "date_level_first")).tag(0)
                            Text(String(localized: "date_level_second")).tag(1)
                            Text(String(localized: "date_level_none")).tag(2)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    VStack {
                        Text(String(localized: "title_aggregate")).bold()
                        Picker("Aggregation by", selection: $selectionTagProject) {
                            Text(String(localized: "aggr_option_project")).tag(0)
                            Text(String(localized: "aggr_option_tag")).tag(1)
                        }
                        .pickerStyle(.segmented)
                    }
                }
                .padding()
                
                let taskAggregator = TaskAggregator(data: Array(tasks
                                                               ))
                let aggregatedTasks = taskAggregator.aggregate(dateSelectorLevel: DateSelectorLevel(rawValue: selectionDate)!, aggregationSelector: AggregationSelector(rawValue: selectionTagProject)!)
                let keys: [String] =  selectionDate == 0 ? Formatter.sortDateStrings(dateStrings: Array(aggregatedTasks.keys)) : Array(aggregatedTasks.keys)
                
                List {
                    ForEach(keys, id: \.self) { key in
                        let value = aggregatedTasks[key]!
                        
                        let subKeys = selectionDate == 1 ? Formatter.sortDateStrings(dateStrings: Array(value.keys)) : Array(value.keys)
                        
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
            .navigationBarTitle(String(localized: "tab_reporting_title"))
            //.navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func validateDate() {
        if fromDate > toDate {
            showAlert = true
        }
    }
}

struct ReportingView_Previews: PreviewProvider {
    static var previews: some View {
        ReportingView(refresherWrapper: RefresherWrapper())
    }
}
