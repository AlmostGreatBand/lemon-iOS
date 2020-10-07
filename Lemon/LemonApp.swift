//
//  LemonApp.swift
//  Lemon
//
//  Created by Vsevolod Pavlovskyi on 07.10.2020.
//

import SwiftUI

@main
struct LemonApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
