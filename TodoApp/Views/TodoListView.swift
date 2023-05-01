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
                    ForEach(tasks) { task in
                        if viewModel.editMode == .active {
                            if let title = task.title {
                                EditView(title: title, task: task)
                                    .focused($focus, equals: .editText)
                            }
                        } else {
                            if let title = task.title {
                                ListView(title: title, isCheck: task.checked)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        task.checked.toggle()
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    }
                                    .transaction { transaction in
                                        transaction.animation = nil
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            viewModel.rowDelete(context: viewContext, task: task)
                                        } label: {
                                            Image(systemName: "trash")
                                        }
                                    }
                                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                        Button {
                                            task.color.toggle()
                                        } label: {
                                            // 画像なし
                                        }
                                        .tint(Color("Highlight"))
                                    }
                                    .listRowBackground(viewModel.listColor(context: viewContext, task: task))
                            }
                        }
                    }
                    .onDelete { index in
                        viewModel.rowDelete(context: viewContext, tasks: tasks, offsets: index)
                    }
                    if viewModel.isEditText == true {
                        DraftView(count: mappedTitle.count)
                            .focused($focus, equals: .newText)
                    }
                }
                .padding()
                .padding(.top, 20)
                .listStyle(.inset)
                .environment(\.editMode, $viewModel.editMode)
                .environment(\.defaultMinListRowHeight, 55)
                .onChange(of: mappedTitle, perform: { value in
                    viewModel.isListCountCheck(count: value.count)
                })
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        ToolbarView(tasks: tasks, count: mappedTitle.count)
                    }
                }
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
        .if(viewModel.isEditText == true) { view in
            view.onTapGesture {
                switch focus {
                case .newText:
                    if viewModel.newTitle.count > 0 {
                        viewModel.createTask(context: viewContext, title: viewModel.newTitle)
                        viewModel.isEditText = false
                        focus = nil
                    } else {
                        viewModel.isEditText = false
                        focus = nil
                    }
                case .editText:
                    viewModel.isEditText = false
                    focus = nil
                case .none:
                    break
                }
            }
        }
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
