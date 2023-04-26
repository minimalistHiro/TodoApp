//
//  FocusSample.swift
//  TodoApp
//
//  Created by 金子広樹 on 2023/04/24.
//

import SwiftUI

struct FocusSample: View {
    @State private var name = ""
    @FocusState private var nameFieldIsFocused: Bool   // フォーカス状態プロパティ
    
    var body: some View {
        VStack {
            Spacer().frame(height: 100)
 
            /// フォーカスの制御
            HStack {
                Button("フォーカス in") { nameFieldIsFocused = true}
                    .disabled(!nameFieldIsFocused)
                Button("フォーカス out") { nameFieldIsFocused = false}
                    .disabled(nameFieldIsFocused)
            }
            .buttonStyle(.borderedProminent)
 
            TextField("あなたの名前", text: $name)
                .focused($nameFieldIsFocused)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("こんにちは、\(name)さん")
 
            Spacer()
        }
    }
}

struct FocusSample_Previews: PreviewProvider {
    static var previews: some View {
        FocusSample()
    }
}
