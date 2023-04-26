//
//  haki.swift
//  TodoApp
//
//  Created by 金子広樹 on 2023/04/24.
//

import Foundation

//HStack {
//                                Image(systemName: task.checked ? "checkmark.circle.fill" : "circle")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 25)
//                                    .foregroundColor(Color("Able"))
//                                if let title = task.title {
//                                    if task.checked {
//                                        Text(title)
//                                            .foregroundColor(Color(white: 0.5, opacity: 0.5))
//                                            .strikethrough(color: Color.black)
//                                    } else {
//                                        Text(title)
//                                    }
//                                }
//                                Spacer()
//                            }
//                            .contentShape(Rectangle())
//                            .onTapGesture {
//                                task.checked.toggle()
//                            }
//                            .transaction { transaction in
//                                transaction.animation = nil
//                            }
//                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//                                Button(role: .destructive) {
//                                    viewModel.edit = nil
//                                    viewModel.rowDelete(context: viewContext, task: task)
//                                } label: {
//                                    Image(systemName: "trash")
//                                }
//                            }
//                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
//                                Button {
//                                    viewModel.edit = nil
//                                    task.color.toggle()
//                                } label: {
//                                    // 画像なし
//                                }
//                                .tint(Color("Highlight"))
//                            }
//                            .listRowBackground(viewModel.listColor(context: viewContext, task: task))
