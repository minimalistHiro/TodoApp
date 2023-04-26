//
//  ListRow.swift
//  TodoApp
//
//  Created by 金子広樹 on 2023/04/16.
//

import SwiftUI

struct ListRow: View {
    let title: String
    let isCheck: Bool
    
    var body: some View {
        HStack {
            if isCheck {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color("AppColor"))
                Text(title)
                    .strikethrough()
                    .fontWeight(.ultraLight)
            } else {
                Image(systemName: "circle")
                Text(title)
            }
        }
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ListRow(title: "買い物", isCheck: true)
                .previewLayout(.fixed(width: 300, height: 50))
                .previewDisplayName("Check")
            ListRow(title: "散歩", isCheck: false)
                .previewLayout(.fixed(width: 300, height: 50))
                .previewDisplayName("NotCheck")
        }
    }
}
