//
//  DeleteButton.swift
//  TodoApp
//
//  Created by 金子広樹 on 2023/05/19.
//

import SwiftUI

struct DeleteButton: View {
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject private var viewModel: TodoListViewModel
    var tasks: FetchedResults<Todo>
    var count: Int                          // リストの要素数
    
    var body: some View {
        Button {
            if !viewModel.isCheckCheckedCount(tasks: tasks) {
                // チェック項目がない場合,アラートを表示.
                viewModel.addDeleteAlertEntity()
                viewModel.isShowAlert = true
            } else {
                // チェック項目がある場合,チェック項目のみのタスクを削除.
                viewModel.deleteCheckedTask(context: viewContext, tasks: tasks)
            }
        } label: {
            Image(systemName: "circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60)
                .foregroundColor(Color("Able"))
                .overlay {
                    Image(systemName: "trash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                        .bold()
                        .foregroundColor(Color("Disable"))
                }
        }
        .disabled(viewModel.isShowDeleteButton == false)
    }
}
