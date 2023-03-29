//
//  EDriveApp.swift
//  EDrive
//
//  Created by Andy Yu on 2023/3/29.
//

import SwiftUI

@main
struct EDriveApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
