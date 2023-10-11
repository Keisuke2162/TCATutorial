//
//  TCATutorialApp.swift
//  TCATutorial
//
//  Created by Kei on 2023/10/11.
//

import SwiftUI

@main
struct TCATutorialApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
