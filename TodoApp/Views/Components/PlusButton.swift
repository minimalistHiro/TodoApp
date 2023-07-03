//
//  PlusButton.swift
//  TodoApp
//
//  Created by 金子広樹 on 2023/05/19.
//

import SwiftUI

struct PlusButton: View {
    @EnvironmentObject private var viewModel: TodoListViewModel
    
    var body: some View {
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
                .frame(width: 40)
                .foregroundColor(viewModel.isShowPlusButton ? able : disable)
                .overlay {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .bold()
                        .foregroundColor(disable)
                }
        }
        .disabled(viewModel.isShowPlusButton == false)
    }
}
