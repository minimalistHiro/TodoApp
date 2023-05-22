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
                .frame(width: 60)
                .foregroundColor(Color("Able"))
                .overlay {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                        .bold()
                        .foregroundColor(Color("Disable"))
                }
        }
        .disabled(viewModel.isShowPlusButton == false)
    }
}
