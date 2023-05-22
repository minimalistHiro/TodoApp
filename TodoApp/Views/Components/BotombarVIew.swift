//
//  BotombarVIew.swift
//  TodoApp
//
//  Created by 金子広樹 on 2023/05/19.
//

import SwiftUI

struct BotombarVIew: View {
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject private var viewModel: TodoListViewModel
    var tasks: FetchedResults<Todo>
    var count: Int                          // リストの要素数
    
    var body: some View {
        HStack {
            // 削除ボタン
            Button {
                if !viewModel.isCheckCount(tasks: tasks) {
                    // チェック項目がない場合,アラートを表示.
                    viewModel.addDeleteAlertEntity()
                    viewModel.isShowAlert = true
                } else {
                    // チェック項目がある場合,チェック項目のみのタスクを削除.
                    viewModel.deleteCheckedTask(context: viewContext, tasks: tasks)
                }
            } label: {
                Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
                    .foregroundColor($viewModel.editMode.wrappedValue.isEditing || count == 0 ? Color("Disable") : Color("Able"))
            }
            .disabled($viewModel.editMode.wrappedValue.isEditing || count == 0)
            
            Spacer()
            
            // プラスボタン
            Button {
                if viewModel.isPlusAlert {
                    viewModel.addCreateAlertEntity()
                    viewModel.isShowAlert = true
                } else {
                    viewModel.newTitle = ""
                    viewModel.isEditText = true
                }
            } label: {
                Image(systemName: "circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .foregroundColor($viewModel.editMode.wrappedValue.isEditing ? Color("Disable") : Color("Able"))
                    .overlay {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .bold()
                            .foregroundColor($viewModel.editMode.wrappedValue.isEditing ? Color("Able") : Color("Disable"))
                    }
            }
            .disabled($viewModel.editMode.wrappedValue.isEditing)
            
            Spacer()
            
            // 編集ボタン
            Button {
                if $viewModel.editMode.wrappedValue.isEditing == true {
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        $viewModel.editMode.wrappedValue = .inactive
                    }
                } else {
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        $viewModel.editMode.wrappedValue = .active
                    }
                }
            } label: {
                if $viewModel.editMode.wrappedValue.isEditing == true {
                    Image(systemName: "checkmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                        .foregroundColor(Color("Able"))
                } else {
                    Image(systemName: "pencil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                        .foregroundColor(!$viewModel.editMode.wrappedValue.isEditing && count == 0 ? Color("Disable") : Color("Able"))
                }
            }
            .disabled(!$viewModel.editMode.wrappedValue.isEditing && count == 0)
        }
    }
}
