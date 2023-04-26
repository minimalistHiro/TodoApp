//
//  TodoAppApp.swift
//  TodoApp
//
//  Created by 金子広樹 on 2023/04/16.
//

import SwiftUI

@main
struct TodoAppApp: App {
    let persistenceController = PersistenceController()
    
    var body: some Scene {
        WindowGroup {
            TodoListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
