//
//  ListView.swift
//  TodoApp
//
//  Created by 金子広樹 on 2023/04/24.
//

import SwiftUI

struct ListView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FocusState private var focus: Field?
    @StateObject private var viewModel = TodoListViewModel()
    @Binding var editMode: EditMode
    let title: String                       // タスクタイトル
    var isCheck: Bool                       // チェックの有無
    
    var body: some View {
        HStack {
            Image(systemName: isCheck ? "checkmark.circle.fill" : "circle")
                .resizable()
                .scaledToFit()
                .frame(width: 30)
                .foregroundColor(Color("Able"))
                .padding(.trailing, 5)
            if isCheck {
                Text(title)
                    .font(.system(size: 20))
                    .foregroundColor(Color(white: 0.5, opacity: 0.5))
                    .strikethrough(color: .gray)
            } else {
                Text(title)
                    .font(.system(size: 20))
            }
            Spacer()
        }
    }
}
