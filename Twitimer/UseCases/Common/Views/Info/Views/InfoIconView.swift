//
//  InfoIconView.swift
//  Twitimer
//
//  Created by Brais Moure on 3/11/21.
//

import SwiftUI

struct InfoIconView: View {
    
    // Properties
    
    let icon: String
    let text: LocalizedStringKey
    
    // Body
    
    var body: some View {
        HStack(spacing: Size.medium.rawValue) {
            Image(icon).template.resizable().aspectRatio(contentMode: .fit).frame(width: Size.big.rawValue).foregroundColor(.textColor)
            Text(text).font(size: .caption, type: .light).foregroundColor(.textColor)
            Spacer()
        }
    }
}

struct InfoIconView_Previews: PreviewProvider {
    static var previews: some View {
        InfoIconView(icon: "calendar-add", text: "Info text")
    }
}
