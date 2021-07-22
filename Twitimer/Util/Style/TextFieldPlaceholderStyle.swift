//
//  TextFieldPlaceholderStyle.swift
//  Twitimer
//
//  Created by Brais Moure on 23/6/21.
//

import SwiftUI

struct TextFieldPlaceholderStyle: ViewModifier {
    
    var showPlaceHolder: Bool
    var placeholder: LocalizedStringKey

    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceHolder {
                Text(placeholder).font(size: .body).foregroundColor(Color.textColor.opacity(UIConstants.kViewOpacity))
            }
            content
        }
    }
}
