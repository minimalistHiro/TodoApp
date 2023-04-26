//
//  ToolbarView.swift
//  TodoApp
//
//  Created by 金子広樹 on 2023/04/19.
//

import SwiftUI

struct ToolbarView: View {
    @Environment(\.managedObjectContext) var viewContext
    @StateObject private var viewModel = TodoListViewModel()
    @Binding var alertEntity: AlertEntity?
    @Binding var editMode: EditMode
    @Binding var newTitle: String                   // 新規タスクタイトル
    @Binding var isShowAlert: Bool                  // アラート表示有無
    @Binding var isEditText: Bool                   // テキスト編集中の有無
    @Binding var isPlusAlert: Bool                  // 新規タスク作成時のアラートの有無
    var tasks: FetchedResults<Todo>
    
    var body: some View {
        HStack {
            Button {
                if !viewModel.isCheckCount(tasks: tasks) {
                    // チェック項目がない場合,アラートを表示.
                    alertEntity = viewModel.addDeleteAlertEntity()
                    isShowAlert = true
                } else {
                    // チェック項目がある場合,チェック項目のみのタスクを削除.
                    viewModel.deleteCheckedTask(context: viewContext, tasks: tasks)
                }
            } label: {
                Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
                    .foregroundColor($editMode.wrappedValue.isEditing ? Color("Disable") : Color("Able"))
            }
            .disabled($editMode.wrappedValue.isEditing)
            
            Spacer()
            
            Button {
                if isPlusAlert {
                    alertEntity = viewModel.addCreateAlertEntity()
                    isShowAlert = true
                } else {
                    newTitle = ""
                    isEditText = true
                }
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
                    .foregroundColor($editMode.wrappedValue.isEditing ? Color("Disable") : Color("Able"))
            }
            .disabled($editMode.wrappedValue.isEditing)
            
            Spacer()
            
            Button {
                if $editMode.wrappedValue.isEditing == true {
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        $editMode.wrappedValue = .inactive
                    }
                } else {
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        $editMode.wrappedValue = .active
                    }
                }
            } label: {
                if $editMode.wrappedValue.isEditing == true {
                    Image(systemName: "checkmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                        .foregroundColor(Color("Able"))
                } else {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                        .foregroundColor(Color("Able"))
                }
            }
        }
    }
}
