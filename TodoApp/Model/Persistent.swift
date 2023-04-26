//
//  Persistent.swift
//  TodoApp
//
//  Created by 金子広樹 on 2023/04/16.
//

import SwiftUI
import CoreData

struct AlertEntity {
    // アラートボタンの個数
    enum AlertButton {
        case single
        case double
    }
    let title: String
    let message: String
    let actionText: String
    let cancelText: String
    let button: AlertButton
}

// フォーカスがあたるテキストを判断
enum Field: Hashable {
    case newText
    case editText
}

struct PersistenceController {
    let container: NSPersistentContainer
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for num in 0..<5 {
            let newItem = Todo(context: viewContext)
            newItem.title = "Todo\(num)"
            newItem.checked = false
            newItem.createDate = Date().addingTimeInterval(Double(num))
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Todo")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
