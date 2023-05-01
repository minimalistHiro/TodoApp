//
//  Draft.swift
//  TodoApp
//
//  Created by 金子広樹 on 2023/04/16.
//

import SwiftUI

struct DraftView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FocusState private var focus: Field?
    @EnvironmentObject private var viewModel: TodoListViewModel
    var count: Int                          // リストの要素数
    
    var body: some View {
        TextField("", text: $viewModel.newTitle)
            .font(.system(size: 20))
            .onSubmit {
                // タスクタイトルが空白でない場合のみ,新規タスクを作成.
                if viewModel.newTitle != "" {
                    viewModel.createTask(context: viewContext, title: viewModel.newTitle)
                    viewModel.newTitle = ""
                    focus = nil
                    // 行数上限アラートが呼ばれたら,テキストを閉じる.そうでない場合,続けてタスクを作成.
                    if count >= viewModel.listCount - 1 {
                        viewModel.isEditText = false
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            viewModel.isEditText = true
                            focus = .newText
                        }
                    }
                } else {
                    viewModel.isEditText = false
                    focus = nil
                }
            }
            .focused($focus, equals: .newText)
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    focus = .newText
                }
            }
            .onChange(of: viewModel.newTitle, perform: { value in
                // 最大文字数に達したら、それ以上書き込めないようにする
                if value.count > viewModel.titleCount {
                    viewModel.newTitle.removeLast(viewModel.newTitle.count - viewModel.titleCount)
                }
            })
            .submitLabel(count >= viewModel.listCount - 1 ? .done : .next)
    }
}

struct DraftView_Previews: PreviewProvider {
    static var previews: some View {
        DraftView(count: 5)
            .environmentObject(TodoListViewModel())
    }
}
