//
//  NavigationButton.swift
//  Twitimer
//
//  Created by Brais Moure on 17/6/21.
//

import SwiftUI

struct NavigationButton: View {
    
    let text: LocalizedStringKey
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: Size.none.rawValue) {
            HStack {
                Button(action: {
                    action()
                }) {
                    Text(text).font(size: .body, type: .light).foregroundColor(.textColor).multilineTextAlignment(.leading)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.primaryColor)
            }.padding(.bottom, Size.medium.rawValue)
            Divider()
        }
    }
}

struct NavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationButton(text: "Text".localizedKey, action: {
            print("NavigationButton action")
        }).background(Color.backgroundColor)
    }
}
