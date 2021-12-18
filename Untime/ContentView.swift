//
//  ContentView.swift
//  Untime
//
//  Created by Jan Baumann on 28.11.21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var selectedTab = 0
    @StateObject var refresherWrapper = RefresherWrapper()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ProjectsView().tabItem {
                Label(String(localized: "tab_projects_title"), systemImage: "chevron.right.square")
            }
            .tag(0)
            
            ReportingView(refresherWrapper: refresherWrapper).tabItem {
                Label(String(localized: "tab_reporting_title"), systemImage: "list.triangle")
            }
            .tag(1)
            
            GeneralView().tabItem {
                Label(String(localized: "tab_general_title"), systemImage: "gear")
            }
            .tag(2)
        }
        .onChange(of: selectedTab) { newValue in
            refresherWrapper.refresh.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
