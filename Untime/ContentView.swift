//
//  ContentView.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 28.11.21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ProjectsView().tabItem {
                Label("Projects", systemImage: "chevron.right.square")
            }
            .tag(0)
            
            ReportingView().tabItem {
                Label("Reporting", systemImage: "list.triangle")
            }
            .tag(1)
            
            GeneralView().tabItem {
                Label("General", systemImage: "gear")
            }
            .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
