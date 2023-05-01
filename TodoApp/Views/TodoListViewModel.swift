//
//  TodoListViewModel.swift
//  TodoApp
//
//  Created by 金子広樹 on 2023/04/16.
//

import SwiftUI
import CoreData

final class TodoListViewModel: ObservableObject {
    
    @Published var alertEntity: AlertEntity?
    @Published var editMode: EditMode = .inactive       // EditMode変数
    @Published var newTitle: String = ""                // 新規タスクタイトル
    @Published var isShowAlert: Bool = false            // アラート表示有無
    @Published var isEditText: Bool = false             // テキスト編集中の有無
    @Published var isPlusAlert: Bool = false            // 新規タスク作成時のアラートの有無
    let titleCount: Int = 20                            // タイトルの最大文字数
    let listCount: Int = 80                             // リスト行数の上限
    
    // 削除アラートを作成
    func addDeleteAlertEntity() {
        alertEntity = AlertEntity(title: "",
                                  message: "全て削除しますか？",
                                  actionText: "削除",
                                  cancelText: "キャンセル",
                                  button: .double)
    }
    
    // 行数上限アラートを作成
    func addCreateAlertEntity() {
        alertEntity = AlertEntity(title: "",
                                  message: "リストの上限に達しました。",
                                  actionText: "OK",
                                  cancelText: "",
                                  button: .single)
    }
    
    // チェック項目の有無を調べる
    func isCheckCount(tasks: FetchedResults<Todo>) -> Bool {
        var checkCount: Int = 0
        
        for task in tasks {
            if task.checked {
                checkCount += 1
            }
        }
        // チェック項目が1つ以上ある場合True,ない場合false
        if checkCount > 0 {
            return true
        } else {
            return false
        }
    }
    
    // リスト数が上限に達したら,アラートを表示する.
    func isListCountCheck(count: Int) {
        if count >= listCount {
            isPlusAlert = true
        } else {
            isPlusAlert = false
        }
    }
    
    // リストカラー.true = 黄色, false = 白
    func listColor(context: NSManagedObjectContext, task: Todo) -> Color {
        if task.color {
            return Color("Highlight")
        } else {
            return Color("Disable")
        }
    }
    
    // 新規タスクを作成
    func createTask(context: NSManagedObjectContext, title: String) {
        let newTask = Todo(context: context)
        newTask.title = title
        newTask.checked = false
        newTask.createDate = Date()
        saveContext(context: context)
    }
    
    // タスクを編集
    func editTask(context: NSManagedObjectContext, task: Todo, title: String) {
        task.title = title
        task.checked = task.checked
        task.createDate = task.createDate
        saveContext(context: context)
    }
    
    // 行削除
    func rowDelete(context: NSManagedObjectContext, task: Todo) {
        context.delete(task)
        saveContext(context: context)
    }
    
    // 行削除
    func rowDelete(context: NSManagedObjectContext, tasks: FetchedResults<Todo>, offsets: IndexSet) {
        offsets.map { tasks[$0] }.forEach(context.delete)
        saveContext(context: context)
    }
    
    // チェックがついたタスクを削除
    func deleteCheckedTask(context: NSManagedObjectContext, tasks: FetchedResults<Todo>) {
        for task in tasks {
            if(task.checked) {
                context.delete(task)
            }
        }
        saveContext(context: context)
    }
    
    // 全てのタスクを削除
    func deleteAllTask(context: NSManagedObjectContext, tasks: FetchedResults<Todo>) {
        for task in tasks {
            context.delete(task)
        }
        saveContext(context: context)
    }
    
    // Contextを保存
    private func saveContext(context: NSManagedObjectContext) {
        // 管理対象のオブジェクトの変更があった場合のみ保存
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("データ保存失敗")
            }
        }
    }
}
