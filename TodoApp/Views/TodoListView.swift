//
//  ContentView.swift
//  TodoApp
//
//  Created by 金子広樹 on 2023/04/16.
//

import SwiftUI
import CoreData

struct TodoListView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "createDate", ascending: true)], animation: .default)
    var tasks: FetchedResults<Todo>
    
    @FocusState private var focus: Field?
    @EnvironmentObject private var viewModel: TodoListViewModel
    
    var body: some View {
        
        let mappedTitle = tasks.map { value in
            value.title
        }
        NavigationStack {
            List {
                ForEachView(tasks: tasks)
                if viewModel.isEditText {
                    DraftView(count: mappedTitle.count)
                        .focused($focus, equals: .newText)
                        .listRowSeparator(.hidden)
                } else {
                    PlusButton()
                        .listRowSeparator(.hidden)
                }
                Spacer()
                    .listRowSeparator(.hidden)
                Spacer()
                    .listRowSeparator(.hidden)
            }
            .listStyle(.inset)
            .environment(\.defaultMinListRowHeight, 55)
            .padding(.top, 25)
            .padding(.horizontal,10)
            //            .environment(\.editMode, $viewModel.editMode)
//            .overlay(alignment: .bottomTrailing) {
//                PlusButton()
//                    .padding()
//                    .offset(y: viewModel.isShowPlusButton ? 0 : UIScreen.main.bounds.height / 2 )
//                    .animation(Animation.default, value: viewModel.isShowPlusButton)
//            }
            .overlay(alignment: .bottomTrailing) {
                DeleteButton(tasks: tasks, count: mappedTitle.count)
                    .padding(30)
                    .offset(y: viewModel.isShowDeleteButton ? 0 : UIScreen.main.bounds.height / 2 )
                    .animation(Animation.default, value: viewModel.isShowDeleteButton)
            }
            .onAppear {
                viewModel.checkEnableButtons(count: mappedTitle.count)
            }
            .onChange(of: mappedTitle) { value in
                viewModel.checkListCount(count: value.count)
                viewModel.checkEnableButtons(count: value.count)
            }
            .onChange(of: viewModel.isEditText) { value in
                viewModel.checkEnableButtons(count: mappedTitle.count)
            }
            .toolbarBackground(disable, for: .bottomBar)
            .alert(viewModel.alertEntity?.title ?? "",
                   isPresented: $viewModel.isShowAlert,
                   presenting: viewModel.alertEntity) { entity in
                if viewModel.alertEntity?.button == .single {
                    Button(entity.actionText) {
                        viewModel.isShowAlert = false
                    }
                } else {
                    Button(entity.actionText, role: .destructive) {
                        viewModel.deleteAllTask(context: viewContext, tasks: tasks)
                    }
                    Button(entity.cancelText, role: .cancel) {
                        viewModel.isShowAlert = false
                    }
                }
            } message: { entity in
                Text(entity.message)
            }
        }
        // 画面タップでキーボードが閉じる処理
        //        .if(viewModel.isEditText == true) { view in
        //            view.onTapGesture {
        //                switch focus {
        //                case .newText:
        //                    if viewModel.newTitle.count > 0 {
        //                        viewModel.createTask(context: viewContext, title: viewModel.newTitle)
        //                        viewModel.isEditText = false
        //                        focus = nil
        //                    } else {
        //                        viewModel.isEditText = false
        //                        focus = nil
        //                    }
        //                case .editText:
        //                    viewModel.isEditText = false
        //                    focus = nil
        //                case .none:
        //                    break
        //                }
        //            }
        //        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TodoListView()
                .previewDevice("iPhone 14 Pro")
                .previewDisplayName("iPhone 14 Pro")
                .environmentObject(TodoListViewModel())
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            TodoListView()
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE (3rd generation)")
                .environmentObject(TodoListViewModel())
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
