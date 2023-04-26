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
    @StateObject private var viewModel = TodoListViewModel()
    @Binding var alertEntity: AlertEntity?
    @Binding var title: String              // タスクタイトル
    @Binding var isShowAlert: Bool          // アラート表示有無
    @Binding var isEditText: Bool           // テキスト編集中の有無
    var count: Int                          // リストの要素数
    
    var body: some View {
        TextField("", text: $title)
            .font(.system(size: 20))
            .onSubmit {
                // タスクタイトルが空白でない場合のみ,新規タスクを作成.
                if title != "" {
                    viewModel.createTask(context: viewContext, title: title)
                    title = ""
                    focus = nil
                    // 行数上限アラートが呼ばれたら,テキストを閉じる.そうでない場合,続けてタスクを作成.
                    if count >= viewModel.listCount - 1 {
                        isEditText = false
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isEditText = true
                            focus = .newText
                        }
                    }
                } else {
                    isEditText = false
                    focus = nil
                }
            }
            .focused($focus, equals: .newText)
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    focus = .newText
                }
            }
            .onChange(of: title, perform: { value in
                if value.count > viewModel.titleCount {
                    title.removeLast(title.count - viewModel.titleCount)
                }
            })
            .submitLabel(count >= viewModel.listCount - 1 ? .done : .next)
    }
}

struct DraftView_Previews: PreviewProvider {
    static var previews: some View {
        DraftView(alertEntity: .constant(
            AlertEntity(title: "",
                        message: "全て削除しますか？",
                        actionText: "削除",
                        cancelText: "キャンセル",
                        button: .double)),
                  title: .constant("title"),
                  isShowAlert: .constant(false),
                  isEditText: .constant(false),
                  count: 5)
    }
}
