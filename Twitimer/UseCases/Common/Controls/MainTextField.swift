//
//  MainTextField.swift
//  Twitimer
//
//  Created by Brais Moure on 25/8/21.
//

import SwiftUI
import Combine

struct MainTextField: View {
    
    // Properties
    
    @Binding var title: String
    let placeholder: LocalizedStringKey
    var readOnly = false
    var enable = true
    
    private let kTextLimit = 100
    
    // Body
    
    var body: some View {
        
        TextField("", text: $title).onReceive(Just(title)) { _ in
            limitText(kTextLimit)
        }
        .modifier(TextFieldPlaceholderStyle(showPlaceHolder: title.isEmpty, placeholder: placeholder))
        .font(size:.body)
        .foregroundColor(readOnly ? .lightColor : .textColor)
        .accentColor(readOnly ? .lightColor : .textColor)
        .padding(Size.small.rawValue)
        .background(readOnly ? Color.secondaryColor : Color.backgroundColor)
        .clipShape(Capsule())
        .disabled(!enable || readOnly)
    }

    // MARK: Functions
    
    private func limitText(_ upper: Int) {
        if title.count > upper {
            title = String(title.prefix(upper))
        }
    }
    
}

struct MainTextField_Previews: PreviewProvider {
    static var previews: some View {
        MainTextField(title: .constant(""), placeholder: "My placeholder")
    }
}
