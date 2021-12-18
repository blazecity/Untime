//
//  UntimeApp.swift
//  Untime
//
//  Created by Jan Baumann on 28.11.21.
//

import SwiftUI

@main
struct UntimeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

