////
////  Draft.swift
////  TodoApp
////
////  Created by 金子広樹 on 2023/04/16.
////
//
//import SwiftUI
//
//struct EditView: View {
//    @Environment(\.managedObjectContext) var viewContext
//    @FocusState private var focus: Field?
//    @EnvironmentObject private var viewModel: TodoListViewModel
//    @State var title: String                    // タスクタイトル
//    var task: Todo
//
//    var body: some View {
//        TextField("", text: $title)
//            .font(.system(size: 20))
//            .onSubmit {
//                // タスクタイトルが空白でない場合のみ,編集したタスクを作成.
//                if title != "" {
//                    viewModel.updateTask(context: viewContext, task: task, title: title)
//                    viewModel.isEditText = false
//                    focus = nil
//                } else {
//                    viewModel.isEditText = false
//                    focus = nil
//                }
//            }
//            .focused($focus, equals: .editText)
//            .onChange(of: title, perform: { value in
//                if value.count > viewModel.titleCount {
//                    title.removeLast(title.count - viewModel.titleCount)
//                }
//            })
//            .submitLabel(.done)
////            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
////                Button(role: .destructive) {
////                    viewModel.rowDelete(context: viewContext, task: task)
////                } label: {
////                    Image(systemName: "trash")
////                }
////            }
//    }
//}
